//
// Copyright (c) 2023-2024, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import XCTest
@testable import DiasporaNodeInfo

final class LenientIntTests: XCTestCase {
    func testString() throws {
        struct Input: Decodable {
            let value1: LenientInt
            let value2: LenientInt
        }

        let input = """
            {
              "value1": 123,
              "value2": "234"
            }
            """.data(using: .utf8)!

        let decoded = try JSONDecoder().decode(Input.self, from: input)
        XCTAssertEqual(decoded.value1.value, 123)
        XCTAssertEqual(decoded.value2.value, 234)
    }
}
