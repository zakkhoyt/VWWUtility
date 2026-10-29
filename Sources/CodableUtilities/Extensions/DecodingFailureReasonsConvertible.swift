//
//  DecodingFailureReasonsConvertible.swift
//  CodableUtilities
//
//  Created by Zakk Hoyt on 10/28/26.
//

import Foundation

/// An `Error` that can describe why decoding failed in more detail than `localizedDescription`:
/// where it occurred (coding path), underlying errors, contexts, subjects, and other clues.
///
/// Replaces the retroactive `CustomDebugStringConvertible` conformance this package used to add to
/// `DecodingError`. As of Xcode 26.4 the Swift standard library ships its own `DecodingError.debugDescription`
/// (macOS 26.4+), which shadows a retroactive one and fails to compile for older deployment targets.
/// Call `decodingFailureReasons` instead of `debugDescription`.
///
/// `DecodingError` conforms (see `DecodingError+DebugDescription.swift`).
public protocol DecodingFailureReasonsConvertible: Error {
    /// A multi-line `String` describing why decoding failed, where it occurred, any underlying errors, and context clues.
    var decodingFailureReasons: String { get }
}
