//
// Copyright (c) 2023-2024, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation
import Testing
@testable import DiasporaNodeInfo

struct NodeInfo_v2_0_Tests {
    @Test func mastodonSocial() throws {
        let nodeInfoInput = """
        {
            "version": "2.0",
            "software":
            {
                "name": "mastodon",
                "version": "4.1.5+nightly-2023-07-28"
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
                    "total": 1479509,
                    "activeMonth": 470481,
                    "activeHalfyear": 776979
                },
                "localPosts": 62251340
            },
            "openRegistrations": true,
            "metadata":
            {}
        }
        """.data(using: .utf8)!

        let nodeInfo = try JSONDecoder().decode(NodeInfo.self, from: nodeInfoInput)
        #expect(nodeInfo.v2_0!.version == "2.0")
        #expect(nodeInfo.v2_0!.software.name == "mastodon")
        #expect(nodeInfo.v2_0!.software.version == "4.1.5+nightly-2023-07-28")
        #expect(nodeInfo.v2_0!.protocols == [.value(.activitypub)])
        #expect(nodeInfo.v2_0!.services?.inbound == [])
        #expect(nodeInfo.v2_0!.services?.outbound == [])
        #expect(nodeInfo.v2_0!.usage.users.total == 1479509)
        #expect(nodeInfo.v2_0!.usage.users.activeMonth == 470481)
        #expect(nodeInfo.v2_0!.usage.users.activeHalfyear == 776979)
        #expect(nodeInfo.v2_0!.usage.localPosts == 62251340)
        #expect(nodeInfo.v2_0!.usage.localComments == nil)
        #expect(nodeInfo.v2_0!.openRegistrations == true)
        #expect(nodeInfo.v2_0!.metadata == [:])
    }

    @Test func pleroma() throws {
        let nodeInfoInput = """
        {
            "metadata":
            {
                "accountActivationRequired": false,
                "features":
                [
                    "pleroma_api",
                    "mastodon_api",
                    "mastodon_api_streaming",
                    "polls",
                    "v2_suggestions",
                    "pleroma_explicit_addressing",
                    "shareable_emoji_packs",
                    "multifetch",
                    "pleroma:api/v1/notifications:include_types_filter",
                    "editing",
                    "blockers_visible",
                    "media_proxy",
                    "chat",
                    "shout",
                    "relay",
                    "pleroma_emoji_reactions",
                    "pleroma_chat_messages",
                    "exposable_reactions",
                    "profile_directory",
                    "pleroma:get:main/ostatus"
                ],
                "federation":
                {
                    "enabled": true,
                    "exclusions": false,
                    "mrf_hashtag":
                    {
                        "federated_timeline_removal":
                        [],
                        "reject":
                        [],
                        "sensitive":
                        [
                            "nsfw"
                        ]
                    },
                    "mrf_hellthread":
                    {
                        "delist_threshold": 10,
                        "reject_threshold": 20
                    },
                    "mrf_policies":
                    [
                        "MediaProxyWarmingPolicy",
                        "HellthreadPolicy",
                        "SimplePolicy",
                        "NoIncomingDeletes",
                        "Bonzi",
                        "NormalizeMarkup",
                        "StopTryingToKillPawoo",
                        "HashtagPolicy"
                    ]
                }
            },
            "openRegistrations": false,
            "protocols":
            [
                "activitypub"
            ],
            "services":
            {
                "inbound":
                [],
                "outbound":
                []
            },
            "software":
            {
                "name": "pleroma",
                "version": "2.5.51-9314-g9528fc46-shitposterclub"
            },
            "usage":
            {
                "localPosts": 2556018,
                "users":
                {
                    "activeHalfyear": 526,
                    "activeMonth": 326,
                    "total": 3382
                }
            },
            "version": "2.0"
        }
        """.data(using: .utf8)!

        let nodeInfo = try JSONDecoder().decode(NodeInfo.self, from: nodeInfoInput)
        #expect(nodeInfo.v2_0!.version == "2.0")
        #expect(nodeInfo.v2_0!.software.name == "pleroma")
        #expect(nodeInfo.v2_0!.software.version == "2.5.51-9314-g9528fc46-shitposterclub")
        #expect(nodeInfo.v2_0!.protocols == [.value(.activitypub)])
        #expect(nodeInfo.v2_0!.services?.inbound == [])
        #expect(nodeInfo.v2_0!.services?.outbound == [])
        #expect(nodeInfo.v2_0!.usage.users.total == 3382)
        #expect(nodeInfo.v2_0!.usage.users.activeMonth == 326)
        #expect(nodeInfo.v2_0!.usage.users.activeHalfyear == 526)
        #expect(nodeInfo.v2_0!.usage.localPosts == 2556018)
        #expect(nodeInfo.v2_0!.usage.localComments == nil)
        #expect(nodeInfo.v2_0!.openRegistrations == false)
        #expect(nodeInfo.v2_0!.metadata == [
            "accountActivationRequired": .bool(false),
            "features": .array([
                .string("pleroma_api"),
                .string("mastodon_api"),
                .string("mastodon_api_streaming"),
                .string("polls"),
                .string("v2_suggestions"),
                .string("pleroma_explicit_addressing"),
                .string("shareable_emoji_packs"),
                .string("multifetch"),
                .string("pleroma:api/v1/notifications:include_types_filter"),
                .string("editing"),
                .string("blockers_visible"),
                .string("media_proxy"),
                .string("chat"),
                .string("shout"),
                .string("relay"),
                .string("pleroma_emoji_reactions"),
                .string("pleroma_chat_messages"),
                .string("exposable_reactions"),
                .string("profile_directory"),
                .string("pleroma:get:main/ostatus"),
            ]),
            "federation": .object([
                "enabled": .bool(true),
                "exclusions": .bool(false),
                "mrf_hashtag": .object([
                    "federated_timeline_removal": .array([]),
                    "reject": .array([]),
                    "sensitive": .array([
                        .string("nsfw"),
                    ])
                ]),
                "mrf_hellthread": .object([
                    "delist_threshold": .number(10),
                    "reject_threshold": .number(20),
                ]),
                "mrf_policies": .array([
                    .string("MediaProxyWarmingPolicy"),
                    .string("HellthreadPolicy"),
                    .string("SimplePolicy"),
                    .string("NoIncomingDeletes"),
                    .string("Bonzi"),
                    .string("NormalizeMarkup"),
                    .string("StopTryingToKillPawoo"),
                    .string("HashtagPolicy"),
                ]),
            ]),
        ])
    }

    @Test func lemmy() throws {
        let nodeInfoInput = """
        {"version":"2.0","software":{"name":"lemmy","version":"0.18.5"},"protocols":["activitypub"],"usage":{"users":{"total":149738,"activeHalfyear":26917,"activeMonth":10536},"localPosts":234483,"localComments":1912053},"openRegistrations":true}
        """.data(using: .utf8)!

        let nodeInfo = try JSONDecoder().decode(NodeInfo.self, from: nodeInfoInput)
        #expect(nodeInfo.v2_0!.version == "2.0")
        #expect(nodeInfo.v2_0!.software.name == "lemmy")
        #expect(nodeInfo.v2_0!.software.version == "0.18.5")
        #expect(nodeInfo.v2_0!.protocols == [.value(.activitypub)])
        #expect(nodeInfo.v2_0!.services == nil)
        #expect(nodeInfo.v2_0!.usage.users.total == 149738)
        #expect(nodeInfo.v2_0!.usage.users.activeMonth == 10536)
        #expect(nodeInfo.v2_0!.usage.users.activeHalfyear == 26917)
        #expect(nodeInfo.v2_0!.usage.localPosts == 234483)
        #expect(nodeInfo.v2_0!.usage.localComments == 1912053)
        #expect(nodeInfo.v2_0!.openRegistrations == true)
        #expect(nodeInfo.v2_0!.metadata == nil)
    }

    @Test func unknownService() throws {
        let nodeInfoInput = """
        {
          "version":"2.0",
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
        #expect(nodeInfo.v2_0!.version == "2.0")
        #expect(nodeInfo.v2_0!.software.name == "lemmy")
        #expect(nodeInfo.v2_0!.software.version == "0.18.5")
        #expect(nodeInfo.v2_0!.protocols == [.value(.activitypub)])
        #expect(nodeInfo.v2_0!.services != nil)
        #expect(nodeInfo.v2_0!.services?.inbound == [.value(.pumpio), .unknown("unexpected-inbound-service")])
        #expect(nodeInfo.v2_0!.services?.outbound == [.value(.smtp), .unknown("unexpected-outbound-service")])
    }

    @Test func unknownProtocol() throws {
        let nodeInfoInput = """
        {
          "version":"2.0",
          "software":{"name":"lemmy","version":"0.18.5"},
          "protocols":["activitypub", "hello-unknown-protocol"],
          "usage":{"users":{"total":149738,"activeHalfyear":26917,"activeMonth":10536},"localPosts":234483,"localComments":1912053},
          "openRegistrations":true
        }
        """.data(using: .utf8)!

        let nodeInfo = try JSONDecoder().decode(NodeInfo.self, from: nodeInfoInput)
        #expect(nodeInfo.v2_0!.version == "2.0")
        #expect(nodeInfo.v2_0!.software.name == "lemmy")
        #expect(nodeInfo.v2_0!.software.version == "0.18.5")
        #expect(nodeInfo.v2_0!.protocols == [.value(.activitypub), .unknown("hello-unknown-protocol")])
        #expect(nodeInfo.v2_0!.services == nil)
    }

    @Test func noUsersFields() throws {
        let nodeInfoInput = """
        {
          "version":"2.0",
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
        #expect(nodeInfo.v2_0!.version == "2.0")
        #expect(nodeInfo.v2_0!.software.name == "lemmy")
        #expect(nodeInfo.v2_0!.software.version == "0.18.5")
        #expect(nodeInfo.v2_0!.protocols == [.value(.activitypub)])
        #expect(nodeInfo.v2_0!.services != nil)
        #expect(nodeInfo.v2_0!.services?.inbound == [.value(.pumpio), .unknown("unexpected-inbound-service")])
        #expect(nodeInfo.v2_0!.services?.outbound == [.value(.smtp), .unknown("unexpected-outbound-service")])
    }

    @Test func usersWithStrings() throws {
        // Some wordpress instances return usage.users.activeMonth as a string.
        // For example https://xn--y9aaaan6ae5bex1bccgcxbfc3mrbjd.xn--y9a3aq/wp-json/activitypub/1.0/nodeinfo
        let nodeInfoInput = """
        {
          "version":"2.0",
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
        #expect(nodeInfo.v2_0!.version == "2.0")
        #expect(nodeInfo.v2_0!.software.name == "lemmy")
        #expect(nodeInfo.v2_0!.software.version == "0.18.5")
        #expect(nodeInfo.v2_0!.protocols == [.value(.activitypub)])
        #expect(nodeInfo.v2_0!.usage.users.total == 149738)
        #expect(nodeInfo.v2_0!.usage.users.activeHalfyear == 26917)
        #expect(nodeInfo.v2_0!.usage.users.activeMonth == 10536)
        #expect(nodeInfo.v2_0!.services != nil)
        #expect(nodeInfo.v2_0!.services?.inbound == [.value(.pumpio), .unknown("unexpected-inbound-service")])
        #expect(nodeInfo.v2_0!.services?.outbound == [.value(.smtp), .unknown("unexpected-outbound-service")])
    }

    @Test func usageCountersPlainInt() throws {
        let usageInput = """
        {
          "users": {
            "total": 149738,
            "activeHalfyear": 26917,
            "activeMonth": 10536
          },
          "localPosts": 234483,
          "localComments": 1912053
        }
        """.data(using: .utf8)!

        let usage = try JSONDecoder().decode(DiasporaNodeInfo.v2_0.Usage.self, from: usageInput)
        #expect(usage.users.total == 149738)
        #expect(usage.users.activeHalfyear == 26917)
        #expect(usage.users.activeMonth == 10536)
        #expect(usage.localPosts == 234483)
        #expect(usage.localComments == 1912053)
    }

    @Test func usageCountersStringInt() throws {
        // Some wordpress instances return usage counters as strings.
        let usageInput = """
        {
          "users": {
            "total": "149738",
            "activeHalfyear": "26917",
            "activeMonth": "10536"
          },
          "localPosts": "234483",
          "localComments": "1912053"
        }
        """.data(using: .utf8)!

        let usage = try JSONDecoder().decode(DiasporaNodeInfo.v2_0.Usage.self, from: usageInput)
        #expect(usage.users.total == 149738)
        #expect(usage.users.activeHalfyear == 26917)
        #expect(usage.users.activeMonth == 10536)
        #expect(usage.localPosts == 234483)
        #expect(usage.localComments == 1912053)
    }

    @Test func usageCountersGarbageToNil() throws {
        let usageInput = """
        {
          "users": {
            "total": true,
            "activeHalfyear": 12.5,
            "activeMonth": "not-a-number"
          },
          "localPosts": null,
          "localComments": false
        }
        """.data(using: .utf8)!

        let usage = try JSONDecoder().decode(DiasporaNodeInfo.v2_0.Usage.self, from: usageInput)
        #expect(usage.users.total == nil)
        #expect(usage.users.activeHalfyear == nil)
        #expect(usage.users.activeMonth == nil)
        #expect(usage.localPosts == nil)
        #expect(usage.localComments == nil)
    }

    @Test func usageCountersMissingKeysAreNil() throws {
        let usageInput = """
        {
          "users": {
          }
        }
        """.data(using: .utf8)!

        let usage = try JSONDecoder().decode(DiasporaNodeInfo.v2_0.Usage.self, from: usageInput)
        #expect(usage.users.total == nil)
        #expect(usage.users.activeHalfyear == nil)
        #expect(usage.users.activeMonth == nil)
        #expect(usage.localPosts == nil)
        #expect(usage.localComments == nil)
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

        let decoded = try JSONDecoder().decode(DiasporaNodeInfo.v2_0.Usage.self, from: usageInput)

        let encoder = JSONEncoder()
        encoder.outputFormatting = .sortedKeys
        let encoded = try encoder.encode(decoded)

        // Non-nil counters are emitted as JSON integers; nil counters
        // (activeHalfyear, localComments) are omitted entirely.
        #expect(String(decoding: encoded, as: UTF8.self) ==
            #"{"localPosts":234483,"users":{"activeMonth":10536,"total":149738}}"#)

        let redecoded = try JSONDecoder().decode(DiasporaNodeInfo.v2_0.Usage.self, from: encoded)
        #expect(redecoded.users.total == decoded.users.total)
        #expect(redecoded.users.activeHalfyear == decoded.users.activeHalfyear)
        #expect(redecoded.users.activeMonth == decoded.users.activeMonth)
        #expect(redecoded.localPosts == decoded.localPosts)
        #expect(redecoded.localComments == decoded.localComments)
    }
}
