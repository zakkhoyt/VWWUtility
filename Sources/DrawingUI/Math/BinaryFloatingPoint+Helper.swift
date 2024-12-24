//
//  BinaryFloatingPoint+Helper.swift
//  WaveSynthesizer-iOS
//
//  Created by Zakk Hoyt on 6/23/19.
//  Copyright © 2019 Zakk Hoyt. All rights reserved.
//

import Foundation

extension BinaryFloatingPoint {
    /// `tau` is an alias for `2 * .pi` and can make for more readable code.
    @inlinable public static var tau: Self { 2.0 * .pi }
}

extension BinaryFloatingPoint {
    /// Rounds a floating point number to some multiple of the given value `nearest`
    /// - Parameter nearest: A fractionating value to round to. Think of this like tick marks on a slider or knob.
    /// - Returns: `self`, but rounded to the nearest multiple of `nearest`
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let v = 1.12345
    /// v.round(nearest: 0.10) // 1.10
    /// v.round(nearest: 0.01) // 1.12
    /// v.round(nearest: 0.15) // 1.15
    /// ```
    public func round(
        nearest: Self
    ) -> Self {
        let n = 1 / nearest
        let numberToRound = self * n
        return numberToRound.rounded() / n
    }
}

extension BinaryFloatingPoint {
    @available(*, unavailable, message: "Use Double(self)")
    public var d: Double {
        Double(self)
    }
    
    @available(*, unavailable, message: "Use Float(self)")
    public var f: Float {
        Float(self)
    }
}



