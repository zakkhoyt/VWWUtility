//
//  Codable+DebugDescription
//  HatchUtilities
//
//  Created by Zakk Hoyt on 7/7/21.
//  Copyright © 2021 Zakk Hoyt. All rights reserved.
//

import Foundation

extension EncodingError: @retroactive CustomDebugStringConvertible {
    /// Returns a `String` describing why the `EncodingError` arose,
    /// where it occurred, any underlying errors, and context clues.
    public var debugDescription: String {
        [
            "EncodingError",
            "error: \(localizedDescription)",
            "subject: \(subject)",
            "context: \(context.debugDescription)",
            "codingPath: \(context.codingPath.absoluteCodingPath)",
            {
                guard let underlyingError = context.underlyingError else { return nil }
                return "underlyingError: \(underlyingError.localizedDescription)"
            }()
        ]
            .compactMap { $0 }
            .joined(separator: "\n")
    }
    
    /// `EncodingError` is an `Enum` type. Each case has an associated value (the first parameter).
    /// This property does its best to exctract the value of that paremter as a descriptive `String` type.
    private var subject: String {
        switch self {
        case .invalidValue(let any, _): "invalidValue: \(String(describing: any))"
        @unknown default: "@unknown default"
        }
    }
    
    /// `EncodingError` is an `Enum` type. Each case has an associated value of type `EncodingError.Context`.
    /// This property does its best to exctract and return that context.
    private var context: Context {
        switch self {
        case .invalidValue(_, let context): return context
        @unknown default: return Context(codingPath: [], debugDescription: "@unknown default")
        }
    }
    
    private func underlyingError(context: Context) -> String? {
        guard let underlyingError = context.underlyingError as? NSError,
              let debugDescription = underlyingError.userInfo["NSDebugDescription"] as? String
        else { return nil }
        return debugDescription
    }
}
