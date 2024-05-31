//
// Copyright (c) 2023, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

public extension DiasporaNodeInfo.v2_1 {
    /// NodeInfo schema version 2.1.
    struct NodeInfo: Codable {
        /// The schema version, must be `2.1`.
        public let version: String

        /// Metadata about server software in use.
        public let software: Software

        /// The protocols supported on this server.
        public let protocols: [ProtocolType]

        /// The third party sites this server can connect to via their application API.
        ///
        /// - Note: the spec defines this as mandatory field but Lemmy ignores it as of 0.19
        public let services: Services?

        /// Whether this server allows open self-registration.
        public let openRegistrations: Bool

        /// Usage statistics for this server.
        public let usage: Usage

        /// Free form key value pairs for software specific values. Clients should not rely on any specific key present.
        ///
        /// - Note: the spec defines this as mandatory field but Lemmy ignores it as of `0.19`
        public let metadata: [String: JSON]?
    }
}
