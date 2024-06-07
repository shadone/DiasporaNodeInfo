//
// Copyright (c) 2021-2024, Denis Dzyubenko <denis@ddenis.info>
//
// SPDX-License-Identifier: BSD-2-Clause
//

import Foundation

/// A convenience wrapper allowing to define Decodable properties of type enum that can contain yet unknown values.
///
/// e.g.
/// ```swift
///   enum Color: String, Decodable, RawRepresentable {
///     case red
///     case cherryRed = "#dd0000"
///     case green
///   }
///
///   struct MyNetworkModel: Decodable {
///     // can be decoded from JSON:
///     // {
///     //   "color": "pink"
///     // }
///     let color: ValueOrUnknown<Color>
///   }
/// ```
public enum ValueOrUnknown<Value: Decodable & RawRepresentable>: Decodable, RawRepresentable
    where Value.RawValue: Decodable
{
    public typealias RawValue = Value.RawValue

    case value(Value)
    case unknown(RawValue)

    /// Return a known value if present.
    public var value: Value? {
        switch self {
        case let .value(value):
            return value
        case .unknown:
            return nil
        }
    }

    public init?(rawValue: Value.RawValue) {
        if let value = Value(rawValue: rawValue) {
            self = .value(value)
        } else {
            self = .unknown(rawValue)
        }
    }

    public var rawValue: Value.RawValue {
        switch self {
        case let .value(value):
            return value.rawValue

        case let .unknown(rawValue):
            return rawValue
        }
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let value = try? container.decode(Value.self) {
            self = .value(value)
        } else {
            let value = try container.decode(RawValue.self)
            self = .unknown(value)
        }
    }
}

/// Optional conformance to Encodable.
extension ValueOrUnknown: Encodable where Value: Codable & RawRepresentable, Value.RawValue: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case let .value(value):
            try container.encode(value)
        case let .unknown(rawValue):
            try container.encode(rawValue)
        }
    }
}

extension ValueOrUnknown: Equatable where Value: Equatable, Value.RawValue: Equatable {
    public static func == (lhs: ValueOrUnknown<Value>, rhs: ValueOrUnknown<Value>) -> Bool {
        switch (lhs, rhs) {
        case let (.value(left), .value(right)):
            return left == right
        case let (.unknown(left), .unknown(right)):
            return left == right
        default:
            return false
        }
    }
}

extension ValueOrUnknown: CustomDebugStringConvertible where Value: CustomDebugStringConvertible, Value.RawValue: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case let .value(value):
            return value.debugDescription
        case let .unknown(rawValue):
            return rawValue.debugDescription
        }
    }
}
