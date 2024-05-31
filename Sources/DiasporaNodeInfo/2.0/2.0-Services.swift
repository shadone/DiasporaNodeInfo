//
// Copyright (c) 2023-2024, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

public extension DiasporaNodeInfo.v2_0 {
    /// The third party sites this server can connect to via their application API.
    struct Services: Codable {
        /// The third party sites this server can retrieve messages from for combined display with regular traffic.
        public let inbound: [ValueOrUnknown<InboundSite>]

        /// The third party sites this server can publish messages to on the behalf of a user.
        public let outbound: [ValueOrUnknown<OutboundSite>]
    }
}
