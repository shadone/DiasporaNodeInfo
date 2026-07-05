//
// Copyright (c) 2023-2024, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation
import Testing
@testable import DiasporaNodeInfo

struct LenientIntTests {
    @Test func string() throws {
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
        #expect(decoded.value1.value == 123)
        #expect(decoded.value2.value == 234)
    }
}
