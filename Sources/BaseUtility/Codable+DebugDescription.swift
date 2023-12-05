//
//  Codable+DebugDescription.swift
//
//  Created by Zakk Hoyt on 11/7/23.
//

import Foundation

extension DecodingError: CustomDebugStringConvertible {
    #warning("FIXME: @zakkhoyt - docc examples")
    /// Returns a `String` describing why the `DecodingError` arose,
    /// where it occurred, any underlying errors, and context clues.
    public var debugDescription: String {
        [
            "DecodingError",
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
    
    /// `DecodingError` is an `Enum` type. Each case has an associated value (the first parameter).
    /// This property does its best to exctract the value of that paremter as a descriptive `String` type.
    private var subject: String {
        #warning("FIXME: @zakkhoyt - Should we use String(describing:) vs hoping for CustomStringConvertible?")
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

extension EncodingError: CustomDebugStringConvertible {
    #warning("FIXME: @zakkhoyt - docc examples")
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
}

extension [CodingKey] {
    /// Represents an array of `[CodingKey]` as a dot delimited `String`.
    /// I.E. "current.state.desired.current"
    fileprivate var absoluteCodingPath: String { map { $0.stringValue }.joined(separator: ".") }
}
