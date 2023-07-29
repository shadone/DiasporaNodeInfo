//
// Copyright (c) 2023, Denis Dzyubenko <denis@ddenis.info>
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
        XCTAssertEqual(nodeInfo.v2_1!.protocols, [.activitypub])
        XCTAssertEqual(nodeInfo.v2_1!.services?.inbound, [])
        XCTAssertEqual(nodeInfo.v2_1!.services?.outbound, [])
        XCTAssertEqual(nodeInfo.v2_1!.usage.users.total, 1)
        XCTAssertEqual(nodeInfo.v2_1!.usage.users.activeMonth, 2)
        XCTAssertEqual(nodeInfo.v2_1!.usage.users.activeHalfyear, 3)
        XCTAssertEqual(nodeInfo.v2_1!.usage.localPosts, 42)
        XCTAssertEqual(nodeInfo.v2_1!.usage.localComments, nil)
        XCTAssertEqual(nodeInfo.v2_1!.openRegistrations, true)
        XCTAssertEqual(nodeInfo.v2_1!.metadata, [:])
    }
}
