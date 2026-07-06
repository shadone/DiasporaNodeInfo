//
// Copyright (c) 2023-2024, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation
import Testing
@testable import DiasporaNodeInfo

struct NodeInfo_v2_1_Tests {
    @Test func simple() throws {
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
        #expect(nodeInfo.v2_1!.version == "2.1")
        #expect(nodeInfo.v2_1!.software.name == "mastodon")
        #expect(nodeInfo.v2_1!.software.version == "1.2.3")
        #expect(nodeInfo.v2_1!.software.homepage == "https://example.com")
        #expect(nodeInfo.v2_1!.software.repository == "https://github.com")
        #expect(nodeInfo.v2_1!.protocols == [.value(.activitypub)])
        #expect(nodeInfo.v2_1!.services?.inbound == [])
        #expect(nodeInfo.v2_1!.services?.outbound == [])
        #expect(nodeInfo.v2_1!.usage.users.total == 1)
        #expect(nodeInfo.v2_1!.usage.users.activeMonth == 2)
        #expect(nodeInfo.v2_1!.usage.users.activeHalfyear == 3)
        #expect(nodeInfo.v2_1!.usage.localPosts == 42)
        #expect(nodeInfo.v2_1!.usage.localComments == nil)
        #expect(nodeInfo.v2_1!.openRegistrations == true)
        #expect(nodeInfo.v2_1!.metadata == [:])
    }

    @Test func unknownService() throws {
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
        #expect(nodeInfo.v2_1!.version == "2.1")
        #expect(nodeInfo.v2_1!.software.name == "lemmy")
        #expect(nodeInfo.v2_1!.software.version == "0.18.5")
        #expect(nodeInfo.v2_1!.protocols == [.value(.activitypub)])
        #expect(nodeInfo.v2_1!.services != nil)
        #expect(nodeInfo.v2_1!.services?.inbound == [.value(.pumpio), .unknown("unexpected-inbound-service")])
        #expect(nodeInfo.v2_1!.services?.outbound == [.value(.smtp), .unknown("unexpected-outbound-service")])
    }

    @Test func unknownProtocol() throws {
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
        #expect(nodeInfo.v2_1!.version == "2.1")
        #expect(nodeInfo.v2_1!.software.name == "lemmy")
        #expect(nodeInfo.v2_1!.software.version == "0.18.5")
        #expect(nodeInfo.v2_1!.protocols == [.value(.activitypub), .unknown("hello-unknown-protocol")])
        #expect(nodeInfo.v2_1!.services == nil)
    }

    @Test func noUsersFields() throws {
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
        #expect(nodeInfo.v2_1!.version == "2.1")
        #expect(nodeInfo.v2_1!.software.name == "lemmy")
        #expect(nodeInfo.v2_1!.software.version == "0.18.5")
        #expect(nodeInfo.v2_1!.protocols == [.value(.activitypub)])
        #expect(nodeInfo.v2_1!.services != nil)
        #expect(nodeInfo.v2_1!.services?.inbound == [.value(.pumpio), .unknown("unexpected-inbound-service")])
        #expect(nodeInfo.v2_1!.services?.outbound == [.value(.smtp), .unknown("unexpected-outbound-service")])
    }

    @Test func usersWithStrings() throws {
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
        #expect(nodeInfo.v2_1!.version == "2.1")
        #expect(nodeInfo.v2_1!.software.name == "lemmy")
        #expect(nodeInfo.v2_1!.software.version == "0.18.5")
        #expect(nodeInfo.v2_1!.protocols == [.value(.activitypub)])
        #expect(nodeInfo.v2_1!.usage.users.total == 149738)
        #expect(nodeInfo.v2_1!.usage.users.activeHalfyear == 26917)
        #expect(nodeInfo.v2_1!.usage.users.activeMonth == 10536)
        #expect(nodeInfo.v2_1!.services != nil)
        #expect(nodeInfo.v2_1!.services?.inbound == [.value(.pumpio), .unknown("unexpected-inbound-service")])
        #expect(nodeInfo.v2_1!.services?.outbound == [.value(.smtp), .unknown("unexpected-outbound-service")])
    }

    @Test func usageCountersRoundTripEncoding() throws {
        // activeHalfyear and localComments are absent so their keys must be
        // omitted on re-encode; activeMonth arrives as a string and must be
        // normalized to a JSON integer.
        let usageInput = """
        {
          "users": {
            "total": 149738,
            "activeMonth": "10536"
          },
          "localPosts": 234483
        }
        """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(DiasporaNodeInfo.v2_1.Usage.self, from: usageInput)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let encoded = try encoder.encode(decoded)

        // Non-nil counters are emitted as JSON integers; nil counters
        // (activeHalfyear, localComments) are omitted entirely.
        #expect(String(decoding: encoded, as: UTF8.self) ==
            #"{"localPosts":234483,"users":{"activeMonth":10536,"total":149738}}"#)

        let redecoded = try JSONDecoder().decode(DiasporaNodeInfo.v2_1.Usage.self, from: encoded)
        #expect(redecoded.users.total == decoded.users.total)
        #expect(redecoded.users.activeHalfyear == decoded.users.activeHalfyear)
        #expect(redecoded.users.activeMonth == decoded.users.activeMonth)
        #expect(redecoded.localPosts == decoded.localPosts)
        #expect(redecoded.localComments == decoded.localComments)
    }
}
