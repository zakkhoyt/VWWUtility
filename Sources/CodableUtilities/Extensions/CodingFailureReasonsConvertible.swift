//
//  CodingFailureReasonsConvertible.swift
//  CodableUtilities
//
//  Created by Zakk Hoyt on 10/28/26.
//

import Foundation

/// An `Error` that can describe why encoding or decoding failed in more detail than `localizedDescription`:
/// where it occurred (coding path), underlying errors, contexts, subjects, and other clues.
///
/// This replaces the retroactive `CustomDebugStringConvertible` conformance this package used to add
/// to `EncodingError` and `DecodingError`. As of Xcode 26.4 the Swift standard library ships its own
/// `debugDescription` for those types (macOS 26.4+), which shadows a retroactive one and fails to
/// compile for older deployment targets. Call these APIs instead of `debugDescription`:
/// * ``Swift/EncodingError/encodingFailureReasons``
/// * ``Swift/DecodingError/decodingFailureReasons``
/// * ``codingFailureReasons`` (either error type, via this protocol)
///
/// ```swift
/// do {
///     let myStruct = try JSONDecoder().decode(MyStruct.self, from: data)
/// } catch let error as any CodingFailureReasonsConvertible {
///     logger.fault("\(error.codingFailureReasons)")
/// }
/// ```
public protocol CodingFailureReasonsConvertible: Error {
    /// A multi-line `String` describing why coding failed, where it occurred, any underlying errors, and context clues.
    var codingFailureReasons: String { get }
}

extension EncodingError: CodingFailureReasonsConvertible {
    public var codingFailureReasons: String {
        encodingFailureReasons
    }
}

extension DecodingError: CodingFailureReasonsConvertible {
    public var codingFailureReasons: String {
        decodingFailureReasons
    }
}
