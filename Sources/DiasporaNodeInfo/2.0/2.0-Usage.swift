//
// Copyright (c) 2023, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

public extension DiasporaNodeInfo.v2_0 {
    /// Usage statistics for this server.
    struct Usage: Codable, Sendable {
        /// Statistics about the users of this server.
        public let users: Users

        /// The amount of posts that were made by users that are registered on this server.
        public let localPosts: Int64?

        /// The amount of comments that were made by users that are registered on this server.
        public let localComments: Int64?

        private enum CodingKeys: String, CodingKey {
            case users
            case localPosts
            case localComments
        }

        public init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            users = try container.decode(Users.self, forKey: .users)
            localPosts = container.decodeLenientInt64IfPresent(forKey: .localPosts)
            localComments = container.decodeLenientInt64IfPresent(forKey: .localComments)
        }

        public func encode(to encoder: any Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(users, forKey: .users)
            try container.encodeIfPresent(localPosts, forKey: .localPosts)
            try container.encodeIfPresent(localComments, forKey: .localComments)
        }

        /// Creates a value for testing or fixture purposes.
        public init(users: Users, localPosts: Int64? = nil, localComments: Int64? = nil) {
            self.users = users
            self.localPosts = localPosts
            self.localComments = localComments
        }
    }
}
