//
// Copyright (c) 2023, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

public extension DiasporaNodeInfo.v2_0 {
    /// Statistics about the users of this server.
    struct Users: Codable, Sendable {
        /// The total amount of on this server registered users.
        public let total: Int64?

        /// The amount of users that signed in at least once in the last 180 days.
        public let activeHalfyear: Int64?

        /// The amount of users that signed in at least once in the last 30 days.
        public let activeMonth: Int64?

        private enum CodingKeys: String, CodingKey {
            case total
            case activeHalfyear
            case activeMonth
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            total = container.decodeLenientInt64IfPresent(forKey: .total)
            activeHalfyear = container.decodeLenientInt64IfPresent(forKey: .activeHalfyear)
            activeMonth = container.decodeLenientInt64IfPresent(forKey: .activeMonth)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encodeIfPresent(total, forKey: .total)
            try container.encodeIfPresent(activeHalfyear, forKey: .activeHalfyear)
            try container.encodeIfPresent(activeMonth, forKey: .activeMonth)
        }
    }
}
