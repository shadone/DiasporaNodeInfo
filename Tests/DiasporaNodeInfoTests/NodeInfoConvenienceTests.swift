//
// Copyright (c) 2026, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation
import Testing
@testable import DiasporaNodeInfo

struct NodeInfoConvenienceTests {
    @Test func v2_0Accessors() throws {
        let nodeInfoInput = """
        {
          "version": "2.0",
          "software": {
            "name": "lemmy",
            "version": "0.18.5"
          },
          "protocols": ["activitypub", "hello-unknown-protocol"],
          "usage": {
            "users": {
              "total": 149738,
              "activeHalfyear": 26917,
              "activeMonth": 10536
            },
            "localPosts": 234483,
            "localComments": 1912053
          },
          "openRegistrations": true
        }
        """.data(using: .utf8)!

        let nodeInfo = try JSONDecoder().decode(NodeInfo.self, from: nodeInfoInput)

        #expect(nodeInfo.softwareName == "lemmy")
        #expect(nodeInfo.softwareVersion == "0.18.5")
        #expect(nodeInfo.softwareHomepage == nil)
        #expect(nodeInfo.softwareRepository == nil)
        #expect(nodeInfo.openRegistrations == true)
        #expect(nodeInfo.protocolNames == ["activitypub", "hello-unknown-protocol"])
        #expect(nodeInfo.usersTotal == 149738)
        #expect(nodeInfo.usersActiveMonth == 10536)
        #expect(nodeInfo.usersActiveHalfyear == 26917)
        #expect(nodeInfo.localPosts == 234483)
        #expect(nodeInfo.localComments == 1912053)
    }

    @Test func v2_1Accessors() throws {
        let nodeInfoInput = """
        {
          "version": "2.1",
          "software": {
            "name": "mastodon",
            "version": "1.2.3",
            "homepage": "https://example.com",
            "repository": "https://github.com/mastodon/mastodon"
          },
          "protocols": ["activitypub"],
          "usage": {
            "users": {
              "total": 1,
              "activeMonth": 2,
              "activeHalfyear": 3
            },
            "localPosts": 42,
            "localComments": 7
          },
          "openRegistrations": false
        }
        """.data(using: .utf8)!

        let nodeInfo = try JSONDecoder().decode(NodeInfo.self, from: nodeInfoInput)

        #expect(nodeInfo.softwareName == "mastodon")
        #expect(nodeInfo.softwareVersion == "1.2.3")
        #expect(nodeInfo.softwareHomepage == "https://example.com")
        #expect(nodeInfo.softwareRepository == "https://github.com/mastodon/mastodon")
        #expect(nodeInfo.openRegistrations == false)
        #expect(nodeInfo.protocolNames == ["activitypub"])
        #expect(nodeInfo.usersTotal == 1)
        #expect(nodeInfo.usersActiveMonth == 2)
        #expect(nodeInfo.usersActiveHalfyear == 3)
        #expect(nodeInfo.localPosts == 42)
        #expect(nodeInfo.localComments == 7)
    }

    @Test func protocolNamesIncludesUnknownRawValues() throws {
        let nodeInfoInput = """
        {
          "version": "2.1",
          "software": {
            "name": "lemmy",
            "version": "0.18.5"
          },
          "protocols": ["activitypub", "some-unknown-protocol"],
          "usage": {
            "users": {}
          },
          "openRegistrations": true
        }
        """.data(using: .utf8)!

        let nodeInfo = try JSONDecoder().decode(NodeInfo.self, from: nodeInfoInput)

        #expect(nodeInfo.protocolNames == ["activitypub", "some-unknown-protocol"])
        #expect(nodeInfo.usersTotal == nil)
        #expect(nodeInfo.usersActiveMonth == nil)
        #expect(nodeInfo.usersActiveHalfyear == nil)
        #expect(nodeInfo.localPosts == nil)
        #expect(nodeInfo.localComments == nil)
    }
}
