//
// Copyright (c) 2023, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

/// JSON Resource Descriptor (JRD) document referencing the supported documents via Link elements.
///
/// See [RFC8288](https://datatracker.ietf.org/doc/html/rfc8288)
///
/// Hosted at `/.well-known/nodeinfo`.
///
/// E.g. https://mastodon.social/.well-known/nodeinfo
struct WellKnownNodeInfo: Decodable {
    /// Describes a type of link relation.
    struct Link: Decodable {
        /// Describes a type of link relation.
        ///
        /// e.g. http://nodeinfo.diaspora.software/ns/schema/2.1
        ///
        /// See ``WellKnownNodeInfoSchema``
        let rel: String

        /// Target URI of the link relation.
        ///
        /// e.g. https://example.org/nodeinfo/2.1
        let href: URL?
    }

    let links: [Link]
}
