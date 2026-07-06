//
// Copyright (c) 2023, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation
import ArgumentParser
import DiasporaNodeInfo

@main
struct NodeInfoCLI: AsyncParsableCommand {
    @Argument(help: "The server to fetch node-info from.")
    var domain: String

    mutating func run() async throws {
        do {
            let nodeinfo = try await NodeInfoManager().fetch(for: domain)
            printSummary(nodeinfo, domain: domain)
        } catch {
            reportError("'\(domain)': \(error.localizedDescription)")
            switch error {
            case let .invalidResponse(underlyingError),
                 let .network(underlyingError):
                reportError(String(describing: underlyingError))
            default:
                break
            }
            throw ExitCode.failure
        }
    }

    private func printSummary(_ nodeinfo: NodeInfo, domain: String) {
        print("\(domain):")
        print("\tSchema: \(nodeinfo.version.shortVersionString)")

        print("\tSoftware:")
        print("\t\tName: \(nodeinfo.softwareName)")
        print("\t\tVersion: \(nodeinfo.softwareVersion)")
        if let homepage = nodeinfo.softwareHomepage {
            print("\t\tHomepage: \(homepage)")
        }
        if let repository = nodeinfo.softwareRepository {
            print("\t\tRepo: \(repository)")
        }

        // Protocols are rendered with their friendly `debugDescription` (e.g.
        // "ActivityPub") rather than the version-agnostic `protocolNames`
        // (raw values, e.g. "activitypub"), and metadata has no
        // version-agnostic accessor at all: both stay a payload-level read.
        let protocolDescriptions: [String]
        let metadata: [String: JSON]?
        switch nodeinfo {
        case let .v2_0(payload):
            protocolDescriptions = payload.protocols.map(\.debugDescription)
            metadata = payload.metadata
        case let .v2_1(payload):
            protocolDescriptions = payload.protocols.map(\.debugDescription)
            metadata = payload.metadata
        }
        print("\tProtocols: \(protocolDescriptions.joined(separator: ", "))")

        print("\tUsage:")
        if let total = nodeinfo.usersTotal {
            print("\t\tUsers (total): \(total)")
        }
        if let activeMonth = nodeinfo.usersActiveMonth {
            print("\t\tUsers (active last month): \(activeMonth)")
        }
        if let activeHalfyear = nodeinfo.usersActiveHalfyear {
            print("\t\tUsers (active last 6 months): \(activeHalfyear)")
        }
        if let localPosts = nodeinfo.localPosts {
            print("\t\tLocal posts: \(localPosts)")
        }
        if let localComments = nodeinfo.localComments {
            print("\t\tLocal comments: \(localComments)")
        }

        print("\tOpen Registration: \(nodeinfo.openRegistrations ? "yes" : "no")")

        if let metadata, !metadata.isEmpty {
            print("\tMetadata:")
            for (key, value) in metadata {
                print("\t\t\(key): \(dump(value))")
            }
        }
    }

    private func reportError(_ message: String) {
        FileHandle.standardError.write(Data("\(message)\n".utf8))
    }

    private func dump(_ value: JSON) -> String {
        switch value {
        case let .string(string):
            return string
        case let .number(decimal):
            return "\(decimal)"
        case let .object(dictionary):
            return dictionary.map { (key, value) in
                "\(key)=\(dump(value))"
            }.joined(separator: ", ")
        case let .array(array):
            return array
                .map { dump($0) }
                .joined(separator: ", ")
        case .bool(let bool):
            return bool ? "yes" : "no"
        case .null:
            return "null"
        }
    }
}
