//
// Copyright (c) 2023, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

public extension DiasporaNodeInfo.v2_0 {
    /// Usage statistics for this server.
    struct Usage: Codable {
        /// Statistics about the users of this server.
        public let users: Users

        /// The amount of posts that were made by users that are registered on this server.
        public let localPosts: UInt?

        /// The amount of comments that were made by users that are registered on this server.
        public let localComments: UInt?
    }
}
