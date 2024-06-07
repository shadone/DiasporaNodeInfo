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

            print("\(domain):")
            print("\tSchema: \(nodeinfo.version.shortVersionString)")

            switch nodeinfo {
            case let .v2_0(nodeinfo):
                print("\tSoftware:")
                print("\t\tName: \(nodeinfo.software.name)")
                print("\t\tVersion: \(nodeinfo.software.version)")

                print("\tProtocols: \(nodeinfo.protocols.map(\.debugDescription).joined(separator: ", "))")

                print("\tUsage:")
                if let total = nodeinfo.usage.users.total?.value {
                    print("\t\tUsers (total): \(total)")
                }
                if let activeMonth = nodeinfo.usage.users.activeMonth?.value {
                    print("\t\tUsers (active last month): \(activeMonth)")
                }
                if let activeHalfyear = nodeinfo.usage.users.activeHalfyear?.value {
                    print("\t\tUsers (active last 6 months): \(activeHalfyear)")
                }
                if let localPosts = nodeinfo.usage.localPosts?.value {
                    print("\t\tLocal posts: \(localPosts)")
                }
                if let localComments = nodeinfo.usage.localComments?.value {
                    print("\t\tLocal posts: \(localComments)")
                }

                print("\tOpen Registration: \(nodeinfo.openRegistrations ? "yes" : "no")")

                if let metadata = nodeinfo.metadata, !metadata.isEmpty {
                    print("\tMetadata:")
                    nodeinfo.metadata?.forEach { (key, value) in
                        print("\t\t\(key): \(dump(value))")
                    }
                }
            case let .v2_1(nodeinfo):
                print("\tSoftware:")
                print("\t\tName: \(nodeinfo.software.name)")
                print("\t\tVersion: \(nodeinfo.software.version)")
                if let homepage = nodeinfo.software.homepage {
                    print("\t\tHomepage: \(homepage)")
                }
                if let repository = nodeinfo.software.repository {
                    print("\t\tRepo: \(repository)")
                }

                print("\tProtocols: \(nodeinfo.protocols.map(\.debugDescription).joined(separator: ", "))")

                print("\tUsage:")
                if let total = nodeinfo.usage.users.total?.value {
                    print("\t\tUsers (total): \(total)")
                }
                if let activeMonth = nodeinfo.usage.users.activeMonth?.value {
                    print("\t\tUsers (active last month): \(activeMonth)")
                }
                if let activeHalfyear = nodeinfo.usage.users.activeHalfyear?.value {
                    print("\t\tUsers (active last 6 months): \(activeHalfyear)")
                }
                if let localPosts = nodeinfo.usage.localPosts?.value {
                    print("\t\tLocal posts: \(localPosts)")
                }
                if let localComments = nodeinfo.usage.localComments?.value {
                    print("\t\tLocal posts: \(localComments)")
                }

                print("\tOpen Registration: \(nodeinfo.openRegistrations ? "yes" : "no")")

                if let metadata = nodeinfo.metadata, !metadata.isEmpty {
                    print("\tMetadata:")
                    nodeinfo.metadata?.forEach { (key, value) in
                        print("\t\t\(key): \(dump(value))")
                    }
                }
            }
        } catch let error as NodeInfoManager.Error {
            switch error {
            case .invalidDomain:
                print("'\(domain)' is not a valid domain name")
            case .unsupported:
                print("'\(domain)' does not support NodeInfo protocol")
            case let .supportedNodeInfoSchemaNotFound(schemas):
                print("'\(domain)' supports unknown to us schemas: \(schemas)")
            case .temporaryUnavailable:
                print("'\(domain)' the server is temporary unavailable")
            case let .invalidResponse(underlayingError):
                print("'\(domain)' the server response parse error: \(underlayingError)")
            }
        } catch {
            print("Unexpected error: \(error)")
        }
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
