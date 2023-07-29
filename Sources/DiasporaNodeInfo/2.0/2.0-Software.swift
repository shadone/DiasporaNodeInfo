//
// Copyright (c) 2023, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

public extension DiasporaNodeInfo.v2_0 {
    /// Metadata about server software in use.
    struct Software: Codable {
        /// The canonical name of this server software.
        public let name: String

        /// The version of this server software.
        public let version: String
    }
}
