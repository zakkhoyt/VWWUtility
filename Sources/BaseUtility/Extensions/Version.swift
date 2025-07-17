//
//  Version.swift
//  HatchDevUtilities
//
//  Created by Zakk Hoyt 03/06/25
//  Copyright © hatch.co 2025
//

public import Foundation

/// Represents a semantic version as a `Comparable` wrapper object.
/// Contains converion to/from `String`
///
/// ## Example
///
/// ```swift
/// let a = Version("1.0.0")
/// let b = Version("1.0.1")
/// if a < b {
///      print("\(a) is less than \(b)")
/// }
/// ```
public struct Version: Sendable, Hashable {
    /// The value of self as a `String`
    public let versionString: String

    // TODO: zakkhoyt - Remove this property from Version (Rest Classic legacy code needs updated)
    public let mandatory: Bool
    
    public var major: Int? {
        guard parts.count >= 1 else { return nil }
        return parts[0]
    }
    
    public var minor: Int? {
        guard parts.count >= 2 else { return nil }
        return parts[1]
    }
    
    public var patch: Int? {
        guard parts.count >= 3 else { return nil }
        return parts[2]
    }

    /// Return a string with redacted major
    /// EX: `"x.485.46"`
    public var redactedMajorDescription: String {
        "x.\(dropMajor().description)"
    }
    
    /// The number of terms (major, minor, patch)
    let maxLength: Int
    
    /// The value of each term (major, minor, patch in that order if present)
    let parts: [Int]
    
    public init(
        _ version: String,
        mandatory: Bool = false
    ) {
        self.versionString = version
        self.mandatory = mandatory
        self.maxLength = version
            .split(separator: ".")
            .compactMap { String($0) }
            .max { $0.count < $1.count }?
            .count ?? 0
        self.parts = versionString
            .split(separator: ".")
            .compactMap { Int(String($0)) ?? 0 }
    }
    
    /// Instantiate using Int values to represent the semantic version parts.
    public init(
        _ major: Int,
        _ minor: Int,
        _ patch: Int,
        mandatory: Bool = false
    ) {
        self.init(
            [major, minor, patch]
                .map { "\($0)" }
                .joined(separator: "."),
            mandatory: mandatory
        )
    }
    
    /// Converts a version string into an integer value by splitting by "."
    /// and adding each section together where higher sections have a higher exponent.
    ///
    ///
    /// ```
    ///  EX: 1.0.0:
    ///
    ///  segments = 3 (3 terms)
    ///  1 + 1 = 2 * 10^3*2 = 2000000
    ///  0 + 1 = 1 * 10^3*1 = 1000
    ///  0 + 1 = 1 * 10^3*0 = 1
    ///  Sum = 2001001
    ///  ```
    /// - Parameter otherVersion: A value can only be calculated with reference to another Version instance.
    /// - Returns: A `Decimal` representation
    public func value(comparing otherVersion: Version) -> Decimal {
        let segments: Int = Version.maxParts(self, otherVersion)
        let maxLength: Int = Version.maxLength(self, otherVersion)
        var total: Decimal = 0
        for i in 0..<segments {
            guard i < parts.count else { continue }
            let power = maxLength * ((segments - 1) - i) // 10^6, 10^3, 10^0, etc...
            let coefficient = pow(10, power) // 1e6, 1e3, 1e0, etc..
            let exists = Decimal(0.1) // This allows us to compare ".0" vs ""
            let base = Decimal(parts[i]) + exists // 1 -> 2, 2 -> 3, etc..
            let value = (coefficient * base)
            total += value
        }
        
        return total
    }
    
    /// Returns the raw/unadjusted underlying value that is used in Comparable.
    /// - Note: When comparing against another, some adjustments to `value` may be made.
    /// In this context the value is not adjusted against another instance.
    /// - Attention: Devs this can be useful for debugging
    public var value: Decimal {
        let segments: Int = parts.count
        var total: Decimal = 0
        for i in 0..<segments {
            guard i < parts.count else { continue }
            let power = maxLength * ((segments - 1) - i) // 10^6, 10^3, 10^0, etc...
            let coefficient = pow(10, power) // 1e6, 1e3, 1e0, etc..
            let exists = Decimal(0.1) // This allows us to compare ".0" vs ""
            let base = Decimal(parts[i]) + exists // 1 -> 2, 2 -> 3, etc..
            let value = (coefficient * base)
            total += value
        }
        
        return total
    }
    
    /// Returrns a Version with the leading value dropped.
    ///
    /// EX: `Version("1.2.3").dropMajor() => "2.3"`
    public func dropMajor() -> Version {
        guard !parts.isEmpty else { return Version(self.versionString) }
        var intParts = parts
        intParts.removeFirst()
        let versionString = intParts.compactMap { String($0) }.joined(separator: ".")
        return Version(versionString)
    }
}

extension Version: CustomStringConvertible {
    public var description: String { versionString }
}

extension Version: Comparable {
    public static func != (left: Version, right: Version) -> Bool {
        left.value(comparing: right) != right.value(comparing: left)
    }

    public static func == (left: Version, right: Version) -> Bool {
        left.value(comparing: right) == right.value(comparing: left)
    }

    public static func < (left: Version, right: Version) -> Bool {
        left.value(comparing: right) < right.value(comparing: left)
    }
    
    public static func > (left: Version, right: Version) -> Bool {
        left.value(comparing: right) > right.value(comparing: left)
    }

    public static func <= (left: Version, right: Version) -> Bool {
        left.value(comparing: right) <= right.value(comparing: left)
    }
    
    public static func >= (left: Version, right: Version) -> Bool {
        left.value(comparing: right) >= right.value(comparing: left)
    }
}

extension Version {
    public static func maxParts(_ left: Version, _ right: Version) -> Int {
        max(left.parts.count, right.parts.count)
    }
    
    public static func maxLength(_ left: Version, _ right: Version) -> Int {
        max(left.maxLength, right.maxLength)
    }
}

/// This extension adds semantic versioning support.
///
/// ## References
///
/// * [semver.org](https://semver.org/)
extension Version {
    public enum Section: Int, CustomStringConvertible {
        case major
        case minor
        case patch
        
        public var description: String {
            switch self {
            case .major: "Major"
            case .minor: "Minor"
            case .patch: "Patch"
            }
        }
    }
    
    /// Returns the value of a `Section`
    ///
    /// EX: `Version("1.2").value(for: .major)` -> 1
    ///
    /// EX: `Version("1.2").value(for: .minor)` -> 2
    ///
    /// EX: `Version("1.2").value(for: .patch)` -> nil
    ///
    /// - Parameter section: The `Section` which to return (most sig fig is lowest index)
    /// - Returns: An `Int` value for the section if present. Else `nil`
    public func value(for section: Section) -> Int? {
        let index = section.rawValue
        guard index < parts.count else { return nil }
        return parts[index]
    }
}

extension Version {
    public static var minimumJsonCommandVersion: Version {
        Version("3.0.785")
    }
}

extension Version: Codable {
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let versionString = try container.decode(String.self)
        self.init(versionString)
    }
    
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(versionString)
    }
}
