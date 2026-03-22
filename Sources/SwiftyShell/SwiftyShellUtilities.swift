//
//  SwiftyShellUtilities.swift
//
//  Utility extensions for SwiftyShell
//

#if os(macOS)

import Foundation

// MARK: - Data Extensions

extension Data {
    /// Converts Data to a hexadecimal string representation
    var hexString: String {
        map { String(format: "%02hhx", $0) }.joined()
    }
}

// MARK: - Bool Extensions

extension Bool {
    /// String representation of Bool
    var boolString: String {
        self ? "true" : "false"
    }
}

// MARK: - Dictionary Extensions

extension Dictionary where Key == String, Value == String {
    /// Formats dictionary as a list with custom separator
    func listDescription(separator: String = ", ") -> String {
        map { "\($0.key): \($0.value)" }.joined(separator: separator)
    }
    
    /// Formats dictionary as a multiline list
    func multilineListDescription() -> String {
        listDescription(separator: "\n")
    }
}

extension Dictionary where Key == String, Value == String? {
    /// Formats dictionary as a list with custom separator, filtering nil values
    func listDescription(separator: String = ", ") -> String {
        compactMapValues { $0 }
            .map { "\($0.key): \($0.value)" }
            .joined(separator: separator)
    }
    
    /// Formats dictionary as a multiline list, filtering nil values
    func multilineListDescription() -> String {
        listDescription(separator: "\n")
    }
}

#endif
