//
// Copyright (c) 2023-2024, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

/// The list of supported NodeInfo schema versions.
public enum WellKnownNodeInfoSchema: String, CustomDebugStringConvertible, Sendable {
    case v2_0 = "http://nodeinfo.diaspora.software/ns/schema/2.0"
    case v2_1 = "http://nodeinfo.diaspora.software/ns/schema/2.1"

    /// Returns the schema string, e.g. `http://nodeinfo.diaspora.software/ns/schema/2.1`
    public var schema: String {
        rawValue
    }

    /// Returns the version string of the supported schema, e.g. `2.1`.
    public var shortVersionString: String {
        switch self {
        case .v2_0: return "2.0"
        case .v2_1: return "2.1"
        }
    }

    public var debugDescription: String { shortVersionString }

    /// List of all schema versions supported by the library, ordered from oldest to newest.
    public static let allOrderedSchemas: [WellKnownNodeInfoSchema] = [
        .v2_0,
        .v2_1,
    ]
}
