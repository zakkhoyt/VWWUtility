//
//  CGSize+Helpers.swift
//
//  Created by Zakk Hoyt on 10/7/21.
//

#if os(macOS)

import CoreGraphics

extension CGSize {
    public init(square: CGFloat) {
        self.init(width: square, height: square)
    }
}

extension CGFloat {
    /// Converts to a string with traling decimal places if not an `Int`.
    /// For example:
    ///
    ///   `CGFloat(122).precisionString(mantissaCount: 1)` -> `"122"`
    ///
    ///   `CGFloat(122.334).precisionString(mantissaCount: 1)` -> `"122.3"`
    ///
    ///   `CGFloat(122.334).precisionString(mantissaCount: 5)` -> `"122.33400"`
    ///
    /// - Parameter mantissaCount: The number of decimal places to include if not `Int`
    /// - Returns: String representation of the number
    public func precisionString(mantissaCount m: Int) -> String {
        String(format: "%.\(CGFloat(Int(self)) == self ? 0 : m)f", self)
//        // For testing
//        let iVal = CGFloat(122).precisionString(mantissaCount: 1)
//        print(iVal)
//        let fVal = CGFloat(122.334).precisionString(mantissaCount: 1)
//        print(fVal)
//        let oVal = CGFloat(122.334).precisionString(mantissaCount: 5)
//        print(oVal)
    }
}

extension String {
    public static func fromFloat<T: BinaryFloatingPoint & CVarArg>(_ f: T, fidelity: Int) -> String {
        String(format: "%.\(T(Int(f)) == f ? 0 : fidelity)f", f)
    }
    
    /// Returns a `String` that represents a formatted floating point number.
    /// A second line of stuff.
    ///
    /// And some stuff
    public init<T: BinaryFloatingPoint & CVarArg>(floatString f: T, fidelity: Int) {
        self = String(format: "%.\(T(Int(f)) == f ? 0 : fidelity)f", f)
    }
}

#endif
