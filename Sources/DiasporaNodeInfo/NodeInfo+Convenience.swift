//
// Copyright (c) 2026, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

/// Flat, version-agnostic reads for the fields shared across (or gracefully
/// absent from) schema versions: each accessor returns the value regardless
/// of the schema case, yielding `nil` where a schema version simply lacks the
/// field (e.g. ``softwareHomepage`` / ``softwareRepository`` on a v2.0
/// payload).
///
/// The payload accessors ``NodeInfo/v2_0`` / ``NodeInfo/v2_1`` remain for the
/// exact schema-shaped types and payload-only surfaces such as `metadata`,
/// `services`, and the typed `protocols` arrays.
public extension NodeInfo {
    /// The canonical name of the server software, regardless of schema version.
    var softwareName: String {
        switch self {
        case let .v2_0(payload): payload.software.name
        case let .v2_1(payload): payload.software.name
        }
    }

    /// The version of the server software, regardless of schema version.
    var softwareVersion: String {
        switch self {
        case let .v2_0(payload): payload.software.version
        case let .v2_1(payload): payload.software.version
        }
    }

    /// The url of the homepage of the server software; `nil` if not reported by this schema version.
    var softwareHomepage: String? {
        switch self {
        case .v2_0: nil
        case let .v2_1(payload): payload.software.homepage
        }
    }

    /// The url of the source code repository of the server software; `nil` if not reported by this schema version.
    var softwareRepository: String? {
        switch self {
        case .v2_0: nil
        case let .v2_1(payload): payload.software.repository
        }
    }

    /// Whether this server allows open self-registration.
    var openRegistrations: Bool {
        switch self {
        case let .v2_0(payload): payload.openRegistrations
        case let .v2_1(payload): payload.openRegistrations
        }
    }

    /// The raw names of the protocols supported on this server, known or unknown.
    var protocolNames: [String] {
        switch self {
        case let .v2_0(payload): payload.protocols.map(\.rawValue)
        case let .v2_1(payload): payload.protocols.map(\.rawValue)
        }
    }

    /// The total amount of registered users on this server.
    var usersTotal: Int64? {
        switch self {
        case let .v2_0(payload): payload.usage.users.total
        case let .v2_1(payload): payload.usage.users.total
        }
    }

    /// The amount of users that signed in at least once in the last 30 days.
    var usersActiveMonth: Int64? {
        switch self {
        case let .v2_0(payload): payload.usage.users.activeMonth
        case let .v2_1(payload): payload.usage.users.activeMonth
        }
    }

    /// The amount of users that signed in at least once in the last 180 days.
    var usersActiveHalfyear: Int64? {
        switch self {
        case let .v2_0(payload): payload.usage.users.activeHalfyear
        case let .v2_1(payload): payload.usage.users.activeHalfyear
        }
    }

    /// The amount of posts that were made by users that are registered on this server.
    var localPosts: Int64? {
        switch self {
        case let .v2_0(payload): payload.usage.localPosts
        case let .v2_1(payload): payload.usage.localPosts
        }
    }

    /// The amount of comments that were made by users that are registered on this server.
    var localComments: Int64? {
        switch self {
        case let .v2_0(payload): payload.usage.localComments
        case let .v2_1(payload): payload.usage.localComments
        }
    }
}
