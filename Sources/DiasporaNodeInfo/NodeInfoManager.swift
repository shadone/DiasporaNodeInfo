//
// Copyright (c) 2023, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

/// Main entry point for fetching node info.
public struct NodeInfoManager {
    // MARK: Public

    public enum Error: Swift.Error {
        /// The given domain was not a valid host name.
        case invalidDomain

        /// The domain does not support NodeInfo protocol.
        case unsupported

        /// The domain supports NodeInfo protocol but we couldn't find a suitable supported version of the schema.
        ///
        /// This could happen if the server supports only a newer version of the spec than the versions we implement.
        ///
        /// - Parameter schemas: the list of schemas that the given domain claims to support.
        case supportedNodeInfoSchemaNotFound(schemas: [String])

        /// The server is temporary unavailable, try again later.
        case temporaryUnavailable

        /// The server response cannot be parsed.
        ///
        /// - Parameter underlayingError: the underlaying JSONDecoder error.
        case invalidResponse(underlayingError: Swift.Error)
    }

    // MARK: Private

    private let session: URLSession
    private let jsonDecoder = JSONDecoder()

    // MARK: Functions

    /// Create a manager for fetching node info using the given network session.
    /// - Parameter session: optional ``URLSession`` that will be used for fetching node info.
    public init(session: URLSession = .shared) {
        self.session = session
    }

    private func discoverNodeInfoUrlFromWellKnownNodeInfo(for domain: String) async throws -> URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = domain
        components.path = "/.well-known/nodeinfo"

        guard let url = components.url else {
            throw Error.invalidDomain
        }

        var request = URLRequest(url: url)
        request.allHTTPHeaderFields = [
            "Accept": "application/json",
        ]
        do {
            let (data, urlResponse) = try await session.data(for: request)
            guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
                fatalError("Huh")
            }

            let statusCode = httpUrlResponse.statusCode

            /// The spec: http://nodeinfo.diaspora.software/protocol.html

            /// 1. A client should first try the HTTPS protocol and fall back to HTTP on
            /// connection errors or if it can’t validate the presented certificate.
            /// **Implementation note**: We choose to ignore this.

            /// 2. A client should follow redirections by the HTTP protocol.
            /// **Implementation note**: Implemented by URLSession for us.

            /// 3. A client should abandon the discovery on a HTTP response status code of 404 or 400
            /// and may mark the host as not supporting the NodeInfo protocol.
            if statusCode == 404 || statusCode == 400 {
                throw Error.unsupported
            }

            /// 4. A client should retry discovery on server errors as indicated by the HTTP response
            /// status code 500.
            if statusCode == 500 {
                // TODO: retry.
                throw Error.temporaryUnavailable
            }

            /// 5. Discovery for media types other than application/json is left unspecified.
            /// **Implementation note**: We ignore the mime type and try to parse response data as JSON.
            assert(httpUrlResponse.mimeType == "application/json")

            /// 6. A client should follow the link matching the highest schema version it supports.
            let wellKnownNodeInfo = try jsonDecoder.decode(WellKnownNodeInfo.self, from: data)

            let allKnownSchemas = WellKnownNodeInfoSchema.allOrderedSchemas.map(\.rawValue)
            let allKnownLinksByRel = wellKnownNodeInfo.links
                .filter { allKnownSchemas.contains($0.rel) }
                .reduce(into: [String: WellKnownNodeInfo.Link]()) { partialResult, link in
                    partialResult[link.rel] = link
                }

            let allKnownLinksOrdered = WellKnownNodeInfoSchema.allOrderedSchemas
                .compactMap { schema -> WellKnownNodeInfo.Link? in
                    allKnownLinksByRel[schema.rawValue]
                }

            if let link = allKnownLinksOrdered.first(where: { $0.href != nil }) {
                return link.href!
            }

            let allSupportedSchemas = wellKnownNodeInfo.links.map(\.rel)
            throw Error.supportedNodeInfoSchemaNotFound(schemas: allSupportedSchemas)
        } catch {
            // TODO: handle network errors?
            throw error
        }
    }

    /// Fetch node info for the given domain name.
    /// - Parameter domain: website domain name, without protocol. E.g. "mastodon.social".
    /// - Returns: ``NodeInfo`` for a given spec version.
    /// - Throws ``NodeInfoManager/Error`` or ``Swift.Error`` in case of a network error.
    public func fetch(for domain: String) async throws -> NodeInfo {
        let nodeInfoUrl = try await discoverNodeInfoUrlFromWellKnownNodeInfo(for: domain)

        var request = URLRequest(url: nodeInfoUrl)

        /// The spec: http://nodeinfo.diaspora.software/protocol.html

        /// When accessing the referenced schema document, a client should set the Accept header
        /// to the application/json media type.
        request.allHTTPHeaderFields = [
            "Accept": "application/json",
        ]

        let (data, urlResponse) = try await session.data(for: request)
        guard let httpUrlResponse = urlResponse as? HTTPURLResponse else {
            fatalError("Huh")
        }

        /// A server must provide the data at least in this media type. A server should set a
        /// Content-Type of application/json; profile="http://nodeinfo.diaspora.software/ns/schema/2.1#",
        /// where the value of profile matches the resolution scope of the NodeInfo schema version
        /// that’s being returned.
        /// **Implementation note**: We choose to skip validating content-type..

        // This is not defined in the spec but we choose to validate the status code the same
        // way it is validated when retrieving the list of supported documents via Link elements.
        let statusCode = httpUrlResponse.statusCode
        if statusCode == 404 || statusCode == 400 {
            throw Error.unsupported
        }
        if statusCode == 500 {
            // TODO: retry.
            throw Error.temporaryUnavailable
        }

        do {
            return try jsonDecoder.decode(NodeInfo.self, from: data)
        } catch {
            throw Error.invalidResponse(underlayingError: error)
        }
    }
}
