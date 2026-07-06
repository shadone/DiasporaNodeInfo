//
// Copyright (c) 2026, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation
import Testing
@testable import DiasporaNodeInfo

struct NodeInfoFixtureTests {
    @Test func roundTripsV2_0FixtureBuiltFromMemberwiseInits() throws {
        let software = DiasporaNodeInfo.v2_0.Software(
            name: "mastodon",
            version: "4.2.0"
        )
        let users = DiasporaNodeInfo.v2_0.Users(
            total: 50,
            activeHalfyear: 25,
            activeMonth: 10
        )
        let usage = DiasporaNodeInfo.v2_0.Usage(
            users: users,
            localPosts: 200,
            localComments: 800
        )
        let services = DiasporaNodeInfo.v2_0.Services(
            inbound: [.value(.rss2_0)],
            outbound: [.value(.diaspora)]
        )
        let payload = DiasporaNodeInfo.v2_0.NodeInfo(
            version: "2.0",
            software: software,
            protocols: [.value(.activitypub)],
            services: services,
            openRegistrations: true,
            usage: usage,
            metadata: ["nodeName": .string("Fixture Node")]
        )

        let data = try JSONEncoder().encode(payload)
        let nodeInfo = try JSONDecoder().decode(NodeInfo.self, from: data)

        #expect(nodeInfo.version == .v2_0)
        let decoded = try #require(nodeInfo.v2_0)

        #expect(decoded.version == "2.0")
        #expect(decoded.software.name == "mastodon")
        #expect(decoded.software.version == "4.2.0")
        #expect(decoded.protocols == [.value(.activitypub)])
        #expect(decoded.services?.inbound == [.value(.rss2_0)])
        #expect(decoded.services?.outbound == [.value(.diaspora)])
        #expect(decoded.openRegistrations == true)
        #expect(decoded.usage.users.total == 50)
        #expect(decoded.usage.users.activeHalfyear == 25)
        #expect(decoded.usage.users.activeMonth == 10)
        #expect(decoded.usage.localPosts == 200)
        #expect(decoded.usage.localComments == 800)
        #expect(decoded.metadata?["nodeName"] == .string("Fixture Node"))
    }

    @Test func roundTripsV2_1FixtureBuiltFromMemberwiseInits() throws {
        let software = DiasporaNodeInfo.v2_1.Software(
            name: "lemmy",
            version: "0.19.5",
            repository: "https://github.com/LemmyNet/lemmy",
            homepage: "https://join-lemmy.org"
        )
        let users = DiasporaNodeInfo.v2_1.Users(
            total: 42,
            activeHalfyear: 30,
            activeMonth: 10
        )
        let usage = DiasporaNodeInfo.v2_1.Usage(
            users: users,
            localPosts: 100,
            localComments: 200
        )
        let services = DiasporaNodeInfo.v2_1.Services(
            inbound: [.value(.rss2_0)],
            outbound: []
        )
        let payload = DiasporaNodeInfo.v2_1.NodeInfo(
            version: "2.1",
            software: software,
            protocols: [.value(.activitypub)],
            services: services,
            openRegistrations: true,
            usage: usage,
            metadata: ["nodeName": .string("Fixture Node")]
        )

        let data = try JSONEncoder().encode(payload)
        let nodeInfo = try JSONDecoder().decode(NodeInfo.self, from: data)

        #expect(nodeInfo.version == .v2_1)
        let decoded = try #require(nodeInfo.v2_1)

        #expect(decoded.version == "2.1")
        #expect(decoded.software.name == "lemmy")
        #expect(decoded.software.version == "0.19.5")
        #expect(decoded.software.repository == "https://github.com/LemmyNet/lemmy")
        #expect(decoded.software.homepage == "https://join-lemmy.org")
        #expect(decoded.protocols == [.value(.activitypub)])
        #expect(decoded.services?.inbound == [.value(.rss2_0)])
        #expect(decoded.services?.outbound == [])
        #expect(decoded.openRegistrations == true)
        #expect(decoded.usage.users.total == 42)
        #expect(decoded.usage.users.activeHalfyear == 30)
        #expect(decoded.usage.users.activeMonth == 10)
        #expect(decoded.usage.localPosts == 100)
        #expect(decoded.usage.localComments == 200)
        #expect(decoded.metadata?["nodeName"] == .string("Fixture Node"))
    }

    @Test func decodingThrowsOnGarbageData() {
        let garbage = Data("not valid nodeinfo json".utf8)
        #expect(throws: (any Error).self) {
            try JSONDecoder().decode(NodeInfo.self, from: garbage)
        }
    }
}
