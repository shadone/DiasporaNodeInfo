//
// Copyright (c) 2026, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

extension KeyedDecodingContainer {
    /// Decodes an `Int64` for the given key, tolerating servers that misrepresent counters.
    ///
    /// Accepts a JSON integer, or a JSON string convertible to `Int64`. A whole-number JSON
    /// float (e.g. `12.0`) decodes as its integer value. Any other representation present at
    /// the key (a non-numeric string, a non-integral float, a bool, `null`) as well as a
    /// missing key yields `nil`, without throwing.
    func decodeLenientInt64IfPresent(forKey key: Key) -> Int64? {
        if let value = try? decode(Int64.self, forKey: key) {
            return value
        }

        if
            let stringValue = try? decode(String.self, forKey: key),
            let value = Int64(stringValue)
        {
            return value
        }

        return nil
    }
}
