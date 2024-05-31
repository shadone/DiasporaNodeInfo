//
// Copyright (c) 2023-2024, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import XCTest
@testable import DiasporaNodeInfo

final class NodeInfo_v2_0_Tests: XCTestCase {
    func testMastodonSocial() throws {
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
        XCTAssertEqual(nodeInfo.v2_0!.version, "2.0")
        XCTAssertEqual(nodeInfo.v2_0!.software.name, "mastodon")
        XCTAssertEqual(nodeInfo.v2_0!.software.version, "4.1.5+nightly-2023-07-28")
        XCTAssertEqual(nodeInfo.v2_0!.protocols, [.activitypub])
        XCTAssertEqual(nodeInfo.v2_0!.services?.inbound, [])
        XCTAssertEqual(nodeInfo.v2_0!.services?.outbound, [])
        XCTAssertEqual(nodeInfo.v2_0!.usage.users.total, 1479509)
        XCTAssertEqual(nodeInfo.v2_0!.usage.users.activeMonth, 470481)
        XCTAssertEqual(nodeInfo.v2_0!.usage.users.activeHalfyear, 776979)
        XCTAssertEqual(nodeInfo.v2_0!.usage.localPosts, 62251340)
        XCTAssertEqual(nodeInfo.v2_0!.usage.localComments, nil)
        XCTAssertEqual(nodeInfo.v2_0!.openRegistrations, true)
        XCTAssertEqual(nodeInfo.v2_0!.metadata, [:])
    }

    func testPleroma() throws {
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
        XCTAssertEqual(nodeInfo.v2_0!.version, "2.0")
        XCTAssertEqual(nodeInfo.v2_0!.software.name, "pleroma")
        XCTAssertEqual(nodeInfo.v2_0!.software.version, "2.5.51-9314-g9528fc46-shitposterclub")
        XCTAssertEqual(nodeInfo.v2_0!.protocols, [.activitypub])
        XCTAssertEqual(nodeInfo.v2_0!.services?.inbound, [])
        XCTAssertEqual(nodeInfo.v2_0!.services?.outbound, [])
        XCTAssertEqual(nodeInfo.v2_0!.usage.users.total, 3382)
        XCTAssertEqual(nodeInfo.v2_0!.usage.users.activeMonth, 326)
        XCTAssertEqual(nodeInfo.v2_0!.usage.users.activeHalfyear, 526)
        XCTAssertEqual(nodeInfo.v2_0!.usage.localPosts, 2556018)
        XCTAssertEqual(nodeInfo.v2_0!.usage.localComments, nil)
        XCTAssertEqual(nodeInfo.v2_0!.openRegistrations, false)
        XCTAssertEqual(nodeInfo.v2_0!.metadata, [
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

    func testLemmy() throws {
        let nodeInfoInput = """
        {"version":"2.0","software":{"name":"lemmy","version":"0.18.5"},"protocols":["activitypub"],"usage":{"users":{"total":149738,"activeHalfyear":26917,"activeMonth":10536},"localPosts":234483,"localComments":1912053},"openRegistrations":true}
        """.data(using: .utf8)!

        let nodeInfo = try JSONDecoder().decode(NodeInfo.self, from: nodeInfoInput)
        XCTAssertEqual(nodeInfo.v2_0!.version, "2.0")
        XCTAssertEqual(nodeInfo.v2_0!.software.name, "lemmy")
        XCTAssertEqual(nodeInfo.v2_0!.software.version, "0.18.5")
        XCTAssertEqual(nodeInfo.v2_0!.protocols, [.activitypub])
        XCTAssertNil(nodeInfo.v2_0!.services)
        XCTAssertEqual(nodeInfo.v2_0!.usage.users.total, 149738)
        XCTAssertEqual(nodeInfo.v2_0!.usage.users.activeMonth, 10536)
        XCTAssertEqual(nodeInfo.v2_0!.usage.users.activeHalfyear, 26917)
        XCTAssertEqual(nodeInfo.v2_0!.usage.localPosts, 234483)
        XCTAssertEqual(nodeInfo.v2_0!.usage.localComments, 1912053)
        XCTAssertEqual(nodeInfo.v2_0!.openRegistrations, true)
        XCTAssertEqual(nodeInfo.v2_0!.metadata, nil)
    }

    func testUnknownService() throws {
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
        XCTAssertEqual(nodeInfo.v2_0!.version, "2.0")
        XCTAssertEqual(nodeInfo.v2_0!.software.name, "lemmy")
        XCTAssertEqual(nodeInfo.v2_0!.software.version, "0.18.5")
        XCTAssertEqual(nodeInfo.v2_0!.protocols, [.activitypub])
        XCTAssertNotNil(nodeInfo.v2_0!.services)
        XCTAssertEqual(nodeInfo.v2_0!.services?.inbound, [.value(.pumpio), .unknown("unexpected-inbound-service")])
        XCTAssertEqual(nodeInfo.v2_0!.services?.outbound, [.value(.smtp), .unknown("unexpected-outbound-service")])
    }
}
