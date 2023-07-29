//
// Copyright (c) 2023, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

public extension DiasporaNodeInfo.v2_0 {
    enum ProtocolType: String, Codable, CustomDebugStringConvertible {
        /// ActivityPub
        ///
        /// See more: https://en.wikipedia.org/wiki/ActivityPub
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

        public var debugDescription: String {
            switch self {
            case .activitypub: return "ActivityPub"
            case .buddycloud: return "Buddcloud"
            case .dfrn: return "DFRN"
            case .diaspora: return "Diaspora"
            case .libertree: return "Libertree"
            case .ostatus: return "OStatus"
            case .pumpio: return "Pump.io"
            case .tent: return "Tent"
            case .xmpp: return "XMPP"
            case .zot: return "Zot"
            }
        }
    }
}
