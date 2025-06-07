//
//  Encodable+JSON.swift
//
//  Created by Scott Marchant on 8/4/22.
//

import Foundation

/// This is an extension to attempt to diff two dictionaries
extension Encodable {
    /// Converts any `Encodable` into `[AnyHashable: Any]?` equivalent.
    /// If `EncodingError` is encountered, check under key `"EncodingError"`
    /// for `encodingError.debugDescription`
    public func jsonDictionary() -> [AnyHashable: Any]? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            return try JSONSerialization.jsonObject(with: data) as? [AnyHashable: Any]
        } catch let encodingError as EncodingError {
            return ["EncodingError": encodingError.debugDescription]
        } catch {
            return nil
        }
    }
    
    /// Converts any `Encodable` into a `String` using prettyPrint and sortedKeys.
    /// Or `EncodingError` if one is encountered.
    public var jsonDescription: String? {
        let encoder = JSONEncoder()
        encoder.setVerboseEncoding()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        do {
            let data = try encoder.encode(self)
            return String(data: data, encoding: .utf8)
        } catch let encodingError as EncodingError {
            return encodingError.debugDescription
        } catch {
            return nil
        }
    }
}

/// Concrete `Error` type for common road blocks.
public enum JsonStringEncodingError: LocalizedError {
    case encodedJsonDataIsNotStringEncoding(
        data: Data,
        stringEncoding: String.Encoding
    )
}

extension JSONEncoder {
    /// Converts an `Encodable` to a `JSON` flavored `String`
    ///
    /// Peforms a normal `JSONEncoder().encode(value)` then attempts to convert the resulting `data` to a `String`
    ///
    /// - Parameter value: The `Encodable` value to encode.
    /// - Parameter encoder: A `JSONEncoder` instance to use. Defaults to `JSONEncoder()`
    /// - Parameter stringEncoding: A `String.Encoding` to use for converting `data` to `String`. Defaults to `.utf8`
    /// - Returns: A JSON `String` representation of value.
    /// - Throws: Any `EncodingError` or `EncodableError`
    public static func encodeJsonString(
        _ value: some Encodable,
        encoder: JSONEncoder = JSONEncoder(),
        stringEncoding: String.Encoding = .utf8
    ) throws -> String {
        let data = try encoder.encode(value)
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw JsonStringEncodingError.encodedJsonDataIsNotStringEncoding(
                data: data,
                stringEncoding: stringEncoding
            )
        }
        return jsonString
    }
}
