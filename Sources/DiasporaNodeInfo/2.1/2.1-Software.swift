//
// Copyright (c) 2023, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

public extension DiasporaNodeInfo.v2_1 {
    /// Metadata about server software in use.
    struct Software: Codable {
        /// The canonical name of this server software.
        public let name: String

        /// The version of this server software.
        public let version: String

        /// The url of the source code repository of this server software.
        public let repository: String?

        /// The url of the homepage of this server software.
        public let homepage: String?
    }
}
