//
//  Codable+DebugDescription
//  CodableUtilities
//
//  Created by Zakk Hoyt on 7/7/21.
//  Copyright © 2021 Zakk Hoyt. All rights reserved.
//

import Foundation

extension DecodingError: DecodingFailureReasonsConvertible {
    public func decodingFailureReasons<Key : CodingKey>(
        decoder: any Decoder,
        container: KeyedDecodingContainer<Key>
    ) -> String {
        guard let jsonSourceURL = decoder.jsonSourceURL else {
            return decodingFailureReasons
        }
        return """
        \(decodingFailureReasons)
        jsonSourceURL: \(jsonSourceURL.path())
        \(decoder.inspectJsonSourceFileShellCommand(container: container))
        """
    }

    
#warning("""
FIXME: zakkhoyt - after porting `func inspectJsonSourceFile` into this package from HatchSwiftPackageGrapher
* add support for CodingUserInfoKey.jsonSourceURLKey to decodingFailureReasons
* add support for func inspectJsonSourceFile to decodingFailureReasons
""")
    /// Returns a `String` describing why the `DecodingError` arose,
    /// where it occurred while parsing the payload, any underlying errors, contexts, subjects,
    /// and other clues.
    public var decodingFailureReasons: String {
        [
            "DecodingError",
            "error: \(localizedDescription)",
            "subject: \(subject)",
            "context: \(context.debugDescription)",
            "codingPath: \(context.codingPath.absoluteCodingPath)",
            {
                // We want to collect as many specifics aas possible.
                guard let underlyingError = context.underlyingError as? NSError else { return "nil" }
                
                let localizedValues: [String?] = [
                    underlyingError.localizedDescription,
                    underlyingError.localizedRecoverySuggestion,
                    underlyingError.localizedFailureReason
                ]
                let recoveryValues: [String] = if let localizedRecoveryOptions = underlyingError.localizedRecoveryOptions {
                    localizedRecoveryOptions
                } else {
                    []
                }
                let userInfoValues: [String?] = underlyingError.userInfo.values.compactMap {
                    $0 as? String
                }
                
                let underlyingErrorMessages = [
                    localizedValues,
                    recoveryValues,
                    userInfoValues
                ]
                    .reduce([], +)
                    .compactMap { $0 }
                    .joined(separator: ". ")

                return "underlyingError: \(underlyingErrorMessages)"
            }()
        ]
            .compactMap { $0 }
            .joined(separator: "\n")
    }
    
    /// `DecodingError` is an `Enum` type. Each case has an associated value (the first parameter).
    /// This property does its best to exctract the value of that paremter as a descriptive `String` type.
    private var subject: String {
        switch self {
        case .typeMismatch(let type, _): return "typeMismatch: \(type)"
        case .valueNotFound(let type, _): return "valueNotFound: \(type)"
        case .keyNotFound(let codingKey, _): return "keyNotFound: \(codingKey)"
        case .dataCorrupted: return "dataCorrupted"
        @unknown default:
            assertionFailure("Developer must add new case for DecodingError.Context")
            return "@unknown"
        }
    }
    
    /// `DecodingError` is an `Enum` type. Each case has an associated value of type `DecodingError.Context`.
    /// This property does its best to exctract and return that context.
    private var context: Context {
        switch self {
        case .typeMismatch(_, let context): return context
        case .valueNotFound(_, let context): return context
        case .keyNotFound(_, let context): return context
        case .dataCorrupted(let context): return context
        @unknown default:
            assertionFailure("Developer must add new case for DecodingError.Context")
            return Context(codingPath: [], debugDescription: "@unknown")
        }
    }
}
