//
// Copyright (c) 2026, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation
import XCTest
@testable import DiasporaNodeInfo

/// Exercises the discovery + fetch flow in ``NodeInfoManager`` against a
/// stubbed `URLSession`. These tests are the regression net for the
/// http://nodeinfo.diaspora.software/protocol.html spec rules — every
/// rule we observe gets at least one test here.
final class NodeInfoManagerTests: XCTestCase {
    private var session: URLSession!
    private var manager: NodeInfoManager!

    override func setUp() {
        super.setUp()
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        manager = NodeInfoManager(session: session)
    }

    override func tearDown() {
        MockURLProtocol.reset()
        session = nil
        manager = nil
        super.tearDown()
    }

    // MARK: - Rule 6: pick the highest supported schema version

    /// When the server advertises both 2.0 and 2.1, the 2.1 link must be
    /// followed (spec rule 6).
    func test_discovery_picksHighestSchemaVersion_whenBothAdvertised() async throws {
        let twentyOneURL = URL(string: "https://example.org/nodeinfo/2.1")!
        let twentyURL = URL(string: "https://example.org/nodeinfo/2.0")!

        MockURLProtocol.stub(url: "https://example.org/.well-known/nodeinfo") { _ in
            (200, jrdJSON([
                ("http://nodeinfo.diaspora.software/ns/schema/2.0", twentyURL),
                ("http://nodeinfo.diaspora.software/ns/schema/2.1", twentyOneURL),
            ]))
        }
        MockURLProtocol.stub(url: twentyOneURL.absoluteString) { _ in
            (200, nodeInfo21JSON())
        }
        MockURLProtocol.stub(url: twentyURL.absoluteString) { _ in
            XCTFail("Should not have fetched 2.0 when 2.1 is available")
            return (500, Data())
        }

        let nodeinfo = try await manager.fetch(for: "example.org")

        XCTAssertEqual(nodeinfo.version, .v2_1)
    }

    /// Reverse advertisement order — same expectation: 2.1 wins. Belt
    /// and braces against any quiet "iterate links in order" regression.
    func test_discovery_picksHighestSchemaVersion_regardlessOfLinkOrder() async throws {
        let twentyOneURL = URL(string: "https://example.org/nodeinfo/2.1")!
        let twentyURL = URL(string: "https://example.org/nodeinfo/2.0")!

        MockURLProtocol.stub(url: "https://example.org/.well-known/nodeinfo") { _ in
            (200, jrdJSON([
                ("http://nodeinfo.diaspora.software/ns/schema/2.1", twentyOneURL),
                ("http://nodeinfo.diaspora.software/ns/schema/2.0", twentyURL),
            ]))
        }
        MockURLProtocol.stub(url: twentyOneURL.absoluteString) { _ in
            (200, nodeInfo21JSON())
        }

        let nodeinfo = try await manager.fetch(for: "example.org")

        XCTAssertEqual(nodeinfo.version, .v2_1)
    }

    /// When 2.1 is advertised but the link has no `href`, fall back to 2.0.
    func test_discovery_fallsBackToLowerSchema_whenHigherHasNilHref() async throws {
        let twentyURL = URL(string: "https://example.org/nodeinfo/2.0")!

        MockURLProtocol.stub(url: "https://example.org/.well-known/nodeinfo") { _ in
            (200, jrdJSONWithRawLinks([
                #"{"rel":"http://nodeinfo.diaspora.software/ns/schema/2.1"}"#,
                #"{"rel":"http://nodeinfo.diaspora.software/ns/schema/2.0","href":"\#(twentyURL.absoluteString)"}"#,
            ]))
        }
        MockURLProtocol.stub(url: twentyURL.absoluteString) { _ in
            (200, nodeInfo20JSON())
        }

        let nodeinfo = try await manager.fetch(for: "example.org")

        XCTAssertEqual(nodeinfo.version, .v2_0)
    }

    /// Only 2.0 advertised — pick it.
    func test_discovery_picks20_whenOnly20Advertised() async throws {
        let twentyURL = URL(string: "https://example.org/nodeinfo/2.0")!

        MockURLProtocol.stub(url: "https://example.org/.well-known/nodeinfo") { _ in
            (200, jrdJSON([
                ("http://nodeinfo.diaspora.software/ns/schema/2.0", twentyURL),
            ]))
        }
        MockURLProtocol.stub(url: twentyURL.absoluteString) { _ in
            (200, nodeInfo20JSON())
        }

        let nodeinfo = try await manager.fetch(for: "example.org")

        XCTAssertEqual(nodeinfo.version, .v2_0)
    }

    /// Only 1.0 / 1.1 advertised — we don't support those, throw the
    /// dedicated error and surface the rels back to the caller.
    func test_discovery_throwsSchemaNotFound_whenOnlyUnsupportedVersionsAdvertised() async {
        MockURLProtocol.stub(url: "https://example.org/.well-known/nodeinfo") { _ in
            (200, jrdJSON([
                ("http://nodeinfo.diaspora.software/ns/schema/1.0",
                 URL(string: "https://example.org/nodeinfo/1.0")!),
                ("http://nodeinfo.diaspora.software/ns/schema/1.1",
                 URL(string: "https://example.org/nodeinfo/1.1")!),
            ]))
        }

        do {
            _ = try await manager.fetch(for: "example.org")
            XCTFail("Expected supportedNodeInfoSchemaNotFound")
        } catch let NodeInfoManager.Error.supportedNodeInfoSchemaNotFound(schemas) {
            XCTAssertEqual(Set(schemas), [
                "http://nodeinfo.diaspora.software/ns/schema/1.0",
                "http://nodeinfo.diaspora.software/ns/schema/1.1",
            ])
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    // MARK: - Rule 3: 404/400 → unsupported

    func test_discovery_throwsUnsupported_on404() async {
        MockURLProtocol.stub(url: "https://example.org/.well-known/nodeinfo") { _ in
            (404, Data())
        }

        await XCTAssertThrowsAsyncError(
            try await manager.fetch(for: "example.org"),
            expecting: NodeInfoManager.Error.unsupported
        )
    }

    func test_discovery_throwsUnsupported_on400() async {
        MockURLProtocol.stub(url: "https://example.org/.well-known/nodeinfo") { _ in
            (400, Data())
        }

        await XCTAssertThrowsAsyncError(
            try await manager.fetch(for: "example.org"),
            expecting: NodeInfoManager.Error.unsupported
        )
    }

    // MARK: - Rule 4: any 5xx → temporaryUnavailable

    func test_discovery_throwsTemporaryUnavailable_on500() async {
        MockURLProtocol.stub(url: "https://example.org/.well-known/nodeinfo") { _ in
            (500, Data())
        }

        await XCTAssertThrowsAsyncError(
            try await manager.fetch(for: "example.org"),
            expecting: NodeInfoManager.Error.temporaryUnavailable
        )
    }

    /// Real Lemmy servers behind reverse proxies serve 502/503/504 on
    /// transient failure. Spec text only mentions 500, but the
    /// transient-failure semantics extend to the whole 5xx range.
    func test_discovery_throwsTemporaryUnavailable_onAny5xx() async {
        for code in [500, 501, 502, 503, 504, 599] {
            MockURLProtocol.stub(url: "https://example.org/.well-known/nodeinfo") { _ in
                (code, Data())
            }

            await XCTAssertThrowsAsyncError(
                try await manager.fetch(for: "example.org"),
                expecting: NodeInfoManager.Error.temporaryUnavailable,
                "status \(code) should map to temporaryUnavailable"
            )
        }
    }

    func test_schemaFetch_throwsTemporaryUnavailable_onAny5xx() async {
        let twentyOneURL = URL(string: "https://example.org/nodeinfo/2.1")!

        for code in [500, 502, 503, 504] {
            MockURLProtocol.reset()
            MockURLProtocol.stub(url: "https://example.org/.well-known/nodeinfo") { _ in
                (200, jrdJSON([
                    ("http://nodeinfo.diaspora.software/ns/schema/2.1", twentyOneURL),
                ]))
            }
            MockURLProtocol.stub(url: twentyOneURL.absoluteString) { _ in
                (code, Data())
            }

            await XCTAssertThrowsAsyncError(
                try await manager.fetch(for: "example.org"),
                expecting: NodeInfoManager.Error.temporaryUnavailable,
                "schema fetch status \(code) should map to temporaryUnavailable"
            )
        }
    }

    // MARK: - Rule 5: discovery content-type is unspecified — must NOT crash on jrd+json

    /// `application/jrd+json` is the RFC 8288 content type for JRD
    /// documents. The previous DEBUG-only `assert` would crash here.
    func test_discovery_acceptsJRDJSONContentType() async throws {
        let twentyOneURL = URL(string: "https://example.org/nodeinfo/2.1")!

        MockURLProtocol.stubWithContentType(url: "https://example.org/.well-known/nodeinfo") { _ in
            (200, jrdJSON([
                ("http://nodeinfo.diaspora.software/ns/schema/2.1", twentyOneURL),
            ]), "application/jrd+json")
        }
        MockURLProtocol.stub(url: twentyOneURL.absoluteString) { _ in
            (200, nodeInfo21JSON())
        }

        let nodeinfo = try await manager.fetch(for: "example.org")

        XCTAssertEqual(nodeinfo.version, .v2_1)
    }

    // MARK: - Misc

    func test_invalidDomain_throwsInvalidDomain() async {
        // Whitespace in host can't be encoded by URLComponents.
        await XCTAssertThrowsAsyncError(
            try await manager.fetch(for: "not a valid host"),
            expecting: NodeInfoManager.Error.invalidDomain
        )
    }
}

// MARK: - Fixtures

private func jrdJSON(_ links: [(rel: String, href: URL)]) -> Data {
    let parts = links.map { rel, href in
        #"{"rel":"\#(rel)","href":"\#(href.absoluteString)"}"#
    }.joined(separator: ",")
    return jrdJSONWithRawLinks([parts])
}

private func jrdJSONWithRawLinks(_ links: [String]) -> Data {
    let body = #"{"links":[\#(links.joined(separator: ","))]}"#
    return Data(body.utf8)
}

private func nodeInfo21JSON() -> Data {
    Data(#"""
    {
      "version": "2.1",
      "software": {
        "name": "lemmy",
        "version": "0.19.0",
        "repository": "https://github.com/LemmyNet/lemmy",
        "homepage": "https://join-lemmy.org"
      },
      "protocols": ["activitypub"],
      "services": { "inbound": [], "outbound": [] },
      "openRegistrations": true,
      "usage": {
        "users": { "total": 100, "activeMonth": 30, "activeHalfyear": 60 },
        "localPosts": 1000,
        "localComments": 5000
      },
      "metadata": {}
    }
    """#.utf8)
}

private func nodeInfo20JSON() -> Data {
    Data(#"""
    {
      "version": "2.0",
      "software": { "name": "mastodon", "version": "4.2.0" },
      "protocols": ["activitypub"],
      "services": { "inbound": [], "outbound": [] },
      "openRegistrations": true,
      "usage": {
        "users": { "total": 50, "activeMonth": 10, "activeHalfyear": 25 },
        "localPosts": 200,
        "localComments": 800
      },
      "metadata": {}
    }
    """#.utf8)
}

// MARK: - URLProtocol stub

private final class MockURLProtocol: URLProtocol {
    typealias StubResponse = (status: Int, body: Data, contentType: String)
    typealias Stub = @Sendable (URLRequest) -> StubResponse

    private struct State {
        var stubs: [String: Stub] = [:]
    }

    private static let lock = NSLock()
    nonisolated(unsafe) private static var state = State()

    static func stub(url: String, respond: @escaping Stub) {
        lock.lock()
        defer { lock.unlock() }
        state.stubs[url] = respond
    }

    static func reset() {
        lock.lock()
        defer { lock.unlock() }
        state = State()
    }

    private static func handler(for url: URL) -> Stub? {
        lock.lock()
        defer { lock.unlock() }
        return state.stubs[url.absoluteString]
    }

    override class func canInit(with _: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        guard let url = request.url, let handler = MockURLProtocol.handler(for: url) else {
            client?.urlProtocol(self, didFailWithError: URLError(.fileDoesNotExist))
            return
        }
        let stub = handler(request)
        let response = HTTPURLResponse(
            url: url,
            statusCode: stub.status,
            httpVersion: "HTTP/1.1",
            headerFields: ["Content-Type": stub.contentType]
        )!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: stub.body)
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

/// Convenience wrappers that let tests pre-populate a stub with the default
/// `application/json` content type via a 2-tuple, or with an explicit
/// content type via a 3-tuple.
private extension MockURLProtocol {
    static func stub(
        url: String,
        respond: @escaping @Sendable (URLRequest) -> (Int, Data)
    ) {
        let wrapped: Stub = { request in
            let (status, body) = respond(request)
            return (status, body, "application/json")
        }
        stub(url: url, respond: wrapped)
    }

    static func stubWithContentType(
        url: String,
        respond: @escaping @Sendable (URLRequest) -> (Int, Data, String)
    ) {
        let wrapped: Stub = { request in
            respond(request)
        }
        stub(url: url, respond: wrapped)
    }
}

// MARK: - Async-throws assertion helper

/// Asserts that `expression` throws an error matching `expected` on the
/// `NodeInfoManager.Error` cases that don't carry an associated `Swift.Error`
/// (which would block automatic Equatable synthesis).
private func XCTAssertThrowsAsyncError<T>(
    _ expression: @autoclosure () async throws -> T,
    expecting expected: NodeInfoManager.Error,
    _ message: String = "",
    file: StaticString = #filePath,
    line: UInt = #line
) async {
    do {
        _ = try await expression()
        XCTFail("Expected \(expected) but no error was thrown. \(message)", file: file, line: line)
    } catch let actual as NodeInfoManager.Error {
        switch (actual, expected) {
        case (.invalidDomain, .invalidDomain),
             (.unsupported, .unsupported),
             (.temporaryUnavailable, .temporaryUnavailable),
             (.nonHTTPResponse, .nonHTTPResponse):
            break
        default:
            XCTFail("Expected \(expected), got \(actual). \(message)", file: file, line: line)
        }
    } catch {
        XCTFail("Expected \(expected), got \(error). \(message)", file: file, line: line)
    }
}
