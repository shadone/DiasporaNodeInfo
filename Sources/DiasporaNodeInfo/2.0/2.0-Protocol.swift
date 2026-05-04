//
// Copyright (c) 2023, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

public extension DiasporaNodeInfo.v2_0 {
    enum ProtocolType: String, Codable, CustomDebugStringConvertible, Sendable {
        /// ActivityPub
        ///
        /// See more:
        ///   - https://en.wikipedia.org/wiki/ActivityPub
        ///   - https://www.w3.org/TR/activitypub/
        case activitypub

        /// Buddycloud
        case buddycloud

        /// DFRN.
        ///
        /// DFRN is a distributed communications protocol which provides privacy and security of communications and also provides the basis for distributed profiles and making connections (friend requests).
        ///
        /// See more: https://github.com/friendica/friendica/blob/develop/spec/dfrn2.pdf
        case dfrn

        /// Diaspora
        ///
        /// See more: https://diasporafoundation.org
        case diaspora

        /// Libertree
        ///
        /// - Note: This protocol is deprecated.
        case libertree

        /// OStatus
        ///
        /// See more: https://en.wikipedia.org/wiki/OStatus
        case ostatus

        /// Pump.io
        ///
        /// See more: http://pump.io
        case pumpio

        /// Tent
        ///
        /// - Note: This protocol is deprecated.
        case tent

        /// XMPP
        ///
        /// See more: https://en.wikipedia.org/wiki/XMPP
        case xmpp

        /// Zot
        ///
        /// - Note: This protocol is deprecated.
        case zot

        /// Webmention
        ///
        /// See more: https://www.w3.org/TR/webmention/
        case webmention

        public var debugDescription: String {
            switch self {
            case .activitypub: "ActivityPub"
            case .buddycloud: "Buddcloud"
            case .dfrn: "DFRN"
            case .diaspora: "Diaspora"
            case .libertree: "Libertree"
            case .ostatus: "OStatus"
            case .pumpio: "Pump.io"
            case .tent: "Tent"
            case .xmpp: "XMPP"
            case .zot: "Zot"
            case .webmention: "Webmention"
            }
        }
    }
}
