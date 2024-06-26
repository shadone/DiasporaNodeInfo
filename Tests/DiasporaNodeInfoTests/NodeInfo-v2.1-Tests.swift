//
// Copyright (c) 2023-2024, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import XCTest
@testable import DiasporaNodeInfo

final class NodeInfo_v2_1_Tests: XCTestCase {
    func testSimple() throws {
        let nodeInfoInput = """
        {
            "version": "2.1",
            "software":
            {
                "name": "mastodon",
                "version": "1.2.3",
                "homepage": "https://example.com",
                "repository": "https://github.com"
            },
            "protocols":
            [
                "activitypub"
            ],
            "services":
            {
                "outbound":
                [],
                "inbound":
                []
            },
            "usage":
            {
                "users":
                {
                    "total": 1,
                    "activeMonth": 2,
                    "activeHalfyear": 3
                },
                "localPosts": 42
            },
            "openRegistrations": true,
            "metadata":
            {}
        }
        """.data(using: .utf8)!

        let nodeInfo = try JSONDecoder().decode(NodeInfo.self, from: nodeInfoInput)
        XCTAssertEqual(nodeInfo.v2_1!.version, "2.1")
        XCTAssertEqual(nodeInfo.v2_1!.software.name, "mastodon")
        XCTAssertEqual(nodeInfo.v2_1!.software.version, "1.2.3")
        XCTAssertEqual(nodeInfo.v2_1!.software.homepage, "https://example.com")
        XCTAssertEqual(nodeInfo.v2_1!.software.repository, "https://github.com")
        XCTAssertEqual(nodeInfo.v2_1!.protocols, [.value(.activitypub)])
        XCTAssertEqual(nodeInfo.v2_1!.services?.inbound, [])
        XCTAssertEqual(nodeInfo.v2_1!.services?.outbound, [])
        XCTAssertEqual(nodeInfo.v2_1!.usage.users.total?.value, 1)
        XCTAssertEqual(nodeInfo.v2_1!.usage.users.activeMonth?.value, 2)
        XCTAssertEqual(nodeInfo.v2_1!.usage.users.activeHalfyear?.value, 3)
        XCTAssertEqual(nodeInfo.v2_1!.usage.localPosts?.value, 42)
        XCTAssertEqual(nodeInfo.v2_1!.usage.localComments?.value, nil)
        XCTAssertEqual(nodeInfo.v2_1!.openRegistrations, true)
        XCTAssertEqual(nodeInfo.v2_1!.metadata, [:])
    }

    func testUnknownService() throws {
        let nodeInfoInput = """
        {
          "version":"2.1",
          "software":{"name":"lemmy","version":"0.18.5"},
          "protocols":["activitypub"],
          "usage":{"users":{"total":149738,"activeHalfyear":26917,"activeMonth":10536},"localPosts":234483,"localComments":1912053},
          "openRegistrations":true,
          "services": {
            "inbound": ["pumpio", "unexpected-inbound-service"],
            "outbound": ["smtp", "unexpected-outbound-service"]
          },
        }
        """.data(using: .utf8)!

        let nodeInfo = try JSONDecoder().decode(NodeInfo.self, from: nodeInfoInput)
        XCTAssertEqual(nodeInfo.v2_1!.version, "2.1")
        XCTAssertEqual(nodeInfo.v2_1!.software.name, "lemmy")
        XCTAssertEqual(nodeInfo.v2_1!.software.version, "0.18.5")
            XCTAssertEqual(nodeInfo.v2_1!.protocols, [.value(.activitypub)])
        XCTAssertNotNil(nodeInfo.v2_1!.services)
        XCTAssertEqual(nodeInfo.v2_1!.services?.inbound, [.value(.pumpio), .unknown("unexpected-inbound-service")])
        XCTAssertEqual(nodeInfo.v2_1!.services?.outbound, [.value(.smtp), .unknown("unexpected-outbound-service")])
    }

    func testUnknownProtocol() throws {
        let nodeInfoInput = """
        {
          "version":"2.1",
          "software":{"name":"lemmy","version":"0.18.5"},
          "protocols":["activitypub", "hello-unknown-protocol"],
          "usage":{"users":{"total":149738,"activeHalfyear":26917,"activeMonth":10536},"localPosts":234483,"localComments":1912053},
          "openRegistrations":true
        }
        """.data(using: .utf8)!

        let nodeInfo = try JSONDecoder().decode(NodeInfo.self, from: nodeInfoInput)
        XCTAssertEqual(nodeInfo.v2_1!.version, "2.1")
        XCTAssertEqual(nodeInfo.v2_1!.software.name, "lemmy")
        XCTAssertEqual(nodeInfo.v2_1!.software.version, "0.18.5")
        XCTAssertEqual(nodeInfo.v2_1!.protocols, [.value(.activitypub), .unknown("hello-unknown-protocol")])
        XCTAssertNil(nodeInfo.v2_1!.services)
    }

    func testNoUsersFields() throws {
        let nodeInfoInput = """
        {
          "version":"2.1",
          "software":{"name":"lemmy","version":"0.18.5"},
          "protocols":["activitypub"],
          "usage":{
            "users":{
            },
          },
          "openRegistrations":true,
          "services": {
            "inbound": ["pumpio", "unexpected-inbound-service"],
            "outbound": ["smtp", "unexpected-outbound-service"]
          },
        }
        """.data(using: .utf8)!

        let nodeInfo = try JSONDecoder().decode(NodeInfo.self, from: nodeInfoInput)
        XCTAssertEqual(nodeInfo.v2_1!.version, "2.1")
        XCTAssertEqual(nodeInfo.v2_1!.software.name, "lemmy")
        XCTAssertEqual(nodeInfo.v2_1!.software.version, "0.18.5")
                XCTAssertEqual(nodeInfo.v2_1!.protocols, [.value(.activitypub)])
        XCTAssertNotNil(nodeInfo.v2_1!.services)
        XCTAssertEqual(nodeInfo.v2_1!.services?.inbound, [.value(.pumpio), .unknown("unexpected-inbound-service")])
        XCTAssertEqual(nodeInfo.v2_1!.services?.outbound, [.value(.smtp), .unknown("unexpected-outbound-service")])
    }

    func testUsersWithStrings() throws {
        // Some wordpress instances return usage.users.activeMonth as a string.
        // For example https://xn--y9aaaan6ae5bex1bccgcxbfc3mrbjd.xn--y9a3aq/wp-json/activitypub/1.0/nodeinfo
        let nodeInfoInput = """
        {
          "version":"2.1",
          "software":{"name":"lemmy","version":"0.18.5"},
          "protocols":["activitypub"],
          "usage":{
            "users":{
              "total":"149738",
              "activeHalfyear":"26917",
              "activeMonth":"10536"
            },
            "localPosts":234483,
            "localComments":1912053
          },
          "openRegistrations":true,
          "services": {
            "inbound": ["pumpio", "unexpected-inbound-service"],
            "outbound": ["smtp", "unexpected-outbound-service"]
          },
        }
        """.data(using: .utf8)!

        let nodeInfo = try JSONDecoder().decode(NodeInfo.self, from: nodeInfoInput)
        XCTAssertEqual(nodeInfo.v2_1!.version, "2.1")
        XCTAssertEqual(nodeInfo.v2_1!.software.name, "lemmy")
        XCTAssertEqual(nodeInfo.v2_1!.software.version, "0.18.5")
                    XCTAssertEqual(nodeInfo.v2_1!.protocols, [.value(.activitypub)])
        XCTAssertEqual(nodeInfo.v2_1!.usage.users.total?.value, 149738)
        XCTAssertEqual(nodeInfo.v2_1!.usage.users.activeHalfyear?.value, 26917)
        XCTAssertEqual(nodeInfo.v2_1!.usage.users.activeMonth?.value, 10536)
        XCTAssertNotNil(nodeInfo.v2_1!.services)
        XCTAssertEqual(nodeInfo.v2_1!.services?.inbound, [.value(.pumpio), .unknown("unexpected-inbound-service")])
        XCTAssertEqual(nodeInfo.v2_1!.services?.outbound, [.value(.smtp), .unknown("unexpected-outbound-service")])
    }
}
