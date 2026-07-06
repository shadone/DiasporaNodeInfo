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

            let summary: Summary
            switch nodeinfo {
            case let .v2_0(payload):
                summary = Summary(payload)
            case let .v2_1(payload):
                summary = Summary(payload)
            }

            printSummary(summary, domain: domain)
        } catch let error as NodeInfoManager.Error {
            reportError("'\(domain)': \(error.localizedDescription)")
            if case let .invalidResponse(underlyingError) = error {
                reportError(String(describing: underlyingError))
            }
            throw ExitCode.failure
        } catch {
            reportError("'\(domain)': unexpected error: \(error)")
            throw ExitCode.failure
        }
    }

    /// A flattened view of either schema version's fields, so printing only
    /// has to be written once.
    private struct Summary {
        let schemaVersion: String
        let softwareName: String
        let softwareVersion: String
        let homepage: String?
        let repository: String?
        let protocols: [String]
        let usersTotal: Int64?
        let usersActiveMonth: Int64?
        let usersActiveHalfyear: Int64?
        let localPosts: Int64?
        let localComments: Int64?
        let openRegistrations: Bool
        let metadata: [String: JSON]?

        init(_ nodeinfo: DiasporaNodeInfo.v2_0.NodeInfo) {
            schemaVersion = nodeinfo.version
            softwareName = nodeinfo.software.name
            softwareVersion = nodeinfo.software.version
            homepage = nil
            repository = nil
            protocols = nodeinfo.protocols.map(\.debugDescription)
            usersTotal = nodeinfo.usage.users.total?.value
            usersActiveMonth = nodeinfo.usage.users.activeMonth?.value
            usersActiveHalfyear = nodeinfo.usage.users.activeHalfyear?.value
            localPosts = nodeinfo.usage.localPosts?.value
            localComments = nodeinfo.usage.localComments?.value
            openRegistrations = nodeinfo.openRegistrations
            metadata = nodeinfo.metadata
        }

        init(_ nodeinfo: DiasporaNodeInfo.v2_1.NodeInfo) {
            schemaVersion = nodeinfo.version
            softwareName = nodeinfo.software.name
            softwareVersion = nodeinfo.software.version
            homepage = nodeinfo.software.homepage
            repository = nodeinfo.software.repository
            protocols = nodeinfo.protocols.map(\.debugDescription)
            usersTotal = nodeinfo.usage.users.total?.value
            usersActiveMonth = nodeinfo.usage.users.activeMonth?.value
            usersActiveHalfyear = nodeinfo.usage.users.activeHalfyear?.value
            localPosts = nodeinfo.usage.localPosts?.value
            localComments = nodeinfo.usage.localComments?.value
            openRegistrations = nodeinfo.openRegistrations
            metadata = nodeinfo.metadata
        }
    }

    private func printSummary(_ summary: Summary, domain: String) {
        print("\(domain):")
        print("\tSchema: \(summary.schemaVersion)")

        print("\tSoftware:")
        print("\t\tName: \(summary.softwareName)")
        print("\t\tVersion: \(summary.softwareVersion)")
        if let homepage = summary.homepage {
            print("\t\tHomepage: \(homepage)")
        }
        if let repository = summary.repository {
            print("\t\tRepo: \(repository)")
        }

        print("\tProtocols: \(summary.protocols.joined(separator: ", "))")

        print("\tUsage:")
        if let total = summary.usersTotal {
            print("\t\tUsers (total): \(total)")
        }
        if let activeMonth = summary.usersActiveMonth {
            print("\t\tUsers (active last month): \(activeMonth)")
        }
        if let activeHalfyear = summary.usersActiveHalfyear {
            print("\t\tUsers (active last 6 months): \(activeHalfyear)")
        }
        if let localPosts = summary.localPosts {
            print("\t\tLocal posts: \(localPosts)")
        }
        if let localComments = summary.localComments {
            print("\t\tLocal comments: \(localComments)")
        }

        print("\tOpen Registration: \(summary.openRegistrations ? "yes" : "no")")

        if let metadata = summary.metadata, !metadata.isEmpty {
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
