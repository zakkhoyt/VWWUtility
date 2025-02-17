//
//  Radix.swift
//
//  Created by Zakk Hoyt on 2024-12-04.
//

/// String form of Swift's integer literal prefixes
///
/// - SeeAlso: Swift Documentation for
/// [Lexical Structure / Integer Literals](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/lexicalstructure/#Integer-Literals)
public enum Radix: CaseIterable {
    case binary
    case octal
    case decimal
    case hexadecimal
    
    public var prefix: String {
        switch self {
        case .binary: "0b"
        case .octal: "0o"
        case .decimal: ""
        case .hexadecimal: "0x"
        }
    }
    
    public var value: Int {
        switch self {
        case .binary: 2
        case .octal: 8
        case .decimal: 10
        case .hexadecimal: 16
        }
    }
    
    public var characters: [Character] {
        let strings = switch self {
        case .binary:
            ["0", "1"]
        case .octal:
            ["0", "1", "2", "3", "4", "5", "6", "7"]
        case .decimal:
            ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        case .hexadecimal:
            ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"]
        }
        return strings.map { Character($0) }
    }
}

extension Radix {
    public func stripPrefix(_ string: String) -> String {
        string.replacingOccurrences(of: prefix, with: "")
    }
    
    public func appendPrefix(_ string: String) -> String {
        prefix + string
    }
    
    /// Strips 'illegal' characters from `inputString` including the Radix prefix.
    ///
    /// EX: "hexString 0xABCD" 0-> "ABCD"
    public func dataString(from inputString: String) -> String {
        stripPrefix(inputString).uppercased().filter {
            characters.contains(String($0))
        }
    }
}
