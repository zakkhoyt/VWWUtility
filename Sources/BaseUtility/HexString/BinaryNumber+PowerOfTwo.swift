//
//  BinaryNumber+PowerOfTwo.swift
//
//  Created by Zakk Hoyt on 6/26/23.
//

extension BinaryInteger {
    /// Returns `true` if `self` is `2` raised to some `UInt`.
    ///
    /// - Precondition: `self > 0`
    ///
    /// **Example:**
    ///
    /// ```swift
    /// (4).isPowerOfTwo     // true
    /// (5).isPowerOfTwo     // false
    /// (-4).isPowerOfTwo    // false
    /// ```
    ///
    /// **SeeAlso:**
    ///
    /// [Stanford bithacks](https://graphics.stanford.edu/~seander/bithacks.html#DetermineIfPowerOf2)
    ///
    public var isPowerOfTwo: Bool {
        (self > 0) && (self & (self - 1) == 0)
    }
}

extension BinaryFloatingPoint {
    /// Returns `true` if `self` is `2` raised to some `UInt`.
    ///
    /// - Precondition: `self > 0.0`
    ///
    /// **Example:**
    ///
    /// ```swift
    /// (2.0).isPowerOfTwo   // true
    /// (2.1).isPowerOfTwo   // false
    /// (-2.0).isPowerOfTwo  // false
    /// ```
    ///
    public var isPowerOfTwo: Bool {
        self > 0 && significand == 1
    }
}

extension BinaryInteger {
    static func pow2(_ exp: Self) -> Self {
//        (0...3).reduce(into: 0) {
//            $0 * 2
//        }
        0
    }
}
