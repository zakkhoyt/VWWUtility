//
//  NullCodable.swift
//
//  Created by Steven Grosmark on 6/10/20.
//  https://github.com/g-mark/NullCodable
//



import Foundation

/// Property wrapper that encodes `nil` optional values as `null`
/// when encoded using `JSONEncoder`.
///
/// For example, adding `@NullCodable` like this:
/// ```swift
/// struct Test: Codable {
///     @NullCodable var name: String? = nil
/// }
/// ```
/// will encode as: "{\\"name\\": null}" - as opposed to the default,
/// which is to omit the property from the encoded json, like: "{}".
///
@propertyWrapper
public struct NullCodable<Wrapped> {
    public var wrappedValue: Wrapped?
    
    public init(wrappedValue: Wrapped?) {
        self.wrappedValue = wrappedValue
    }
}

extension NullCodable: Encodable where Wrapped: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch wrappedValue {
        case .some(let value): try container.encode(value)
        case .none: try container.encodeNil()
        }
    }
}

extension NullCodable: Decodable where Wrapped: Decodable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            wrappedValue = try container.decode(Wrapped.self)
        }
    }
}

extension NullCodable: Equatable where Wrapped: Equatable { }
extension NullCodable: Sendable where Wrapped: Sendable { }

extension KeyedDecodingContainer {
    public func decode<Wrapped>(
        _ type: NullCodable<Wrapped>.Type,
        forKey key: KeyedDecodingContainer<K>.Key
    ) throws -> NullCodable<Wrapped> where Wrapped: Decodable {
        try decodeIfPresent(
            NullCodable<Wrapped>.self,
            forKey: key
        ) ?? NullCodable<Wrapped>(wrappedValue: nil)
    }
}
