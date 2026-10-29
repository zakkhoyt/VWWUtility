//
//  EncodingFailureReasonsConvertible.swift
//  CodableUtilities
//
//  Created by Zakk Hoyt on 10/28/26.
//

import Foundation

/// An `Error` that can describe why encoding failed in more detail than `localizedDescription`:
/// where it occurred (coding path), underlying errors, contexts, subjects, and other clues.
///
/// Replaces the retroactive `CustomDebugStringConvertible` conformance this package used to add to
/// `EncodingError`. As of Xcode 26.4 the Swift standard library ships its own `EncodingError.debugDescription`
/// (macOS 26.4+), which shadows a retroactive one and fails to compile for older deployment targets.
/// Call `encodingFailureReasons` instead of `debugDescription`.
///
/// `EncodingError` conforms (see `EncodingError+DebugDescription.swift`).
public protocol EncodingFailureReasonsConvertible: Error {
    /// A multi-line `String` describing why encoding failed, where it occurred, any underlying errors, and context clues.
    var encodingFailureReasons: String { get }
}
