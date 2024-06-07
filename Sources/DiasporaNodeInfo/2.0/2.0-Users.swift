//
// Copyright (c) 2023, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

public extension DiasporaNodeInfo.v2_0 {
    /// Statistics about the users of this server.
    struct Users: Codable {
        /// The total amount of on this server registered users.
        public let total: LenientInt?

        /// The amount of users that signed in at least once in the last 180 days.
        public let activeHalfyear: LenientInt?

        /// The amount of users that signed in at least once in the last 30 days.
        public let activeMonth: LenientInt?
    }
}
