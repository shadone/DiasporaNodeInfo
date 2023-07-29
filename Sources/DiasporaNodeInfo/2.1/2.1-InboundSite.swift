//
// Copyright (c) 2023, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

public extension DiasporaNodeInfo.v2_1 {
    /// The third party sites this server can retrieve messages from for combined display with regular traffic.
    enum InboundSite: String, Codable {
        case atom1_0 = "atom1.0"
        case gnusocial
        case imap
        case pnut
        case pop3
        case pumpio
        case rss2_0 = "rss2.0"
        case twitter
    }
}
