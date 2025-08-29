//
//  BinaryNumber+PowerOfTwo.swift
//
//  Created by Zakk Hoyt on 6/26/23.
//

import Foundation

extension BinaryInteger where Self: UnsignedInteger {
    // HSD-11801 done
    /// Returns `true` if `self` is `2` raised to some `UInt`.
    ///
    /// - Precondition: `self > 0`
    ///
    /// **Example:**
    ///
    /// ```swift
    /// (4).isPowerOfTwo     // true
    /// (5).isPowerOfTwo     // false
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
