//
// Copyright (c) 2023, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

public extension DiasporaNodeInfo.v2_1 {
    /// The third party sites this server can publish messages to on the behalf of a user.
    enum OutboundSite: String, Codable {
        case atom1_0 = "atom1.0"
        case blogger
        case buddycloud
        case diaspora
        case dreamwidth
        case drupal
        case facebook
        case friendica
        case gnusocial
        case google
        case insanejournal
        case libertree
        case linkedin
        case livejournal
        case mediagoblin
        case myspace
        case pinterest
        case pnut
        case posterous
        case pumpio
        case redmatrix
        case rss2_0 = "rss2.0"
        case smtp
        case tent
        case tumblr
        case twitter
        case wordpress
        case xmpp
    }
}
