//
// Copyright (c) 2024, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

public struct LenientInt: Codable {
    public let value: Int64?

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let value = try? container.decode(Int64.self) {
            self.value = value
            return
        }

        if
            let stringValue = try? container.decode(String.self),
            let value = Int64(stringValue)
        {
            self.value = value
            return
        }

        value = nil
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

