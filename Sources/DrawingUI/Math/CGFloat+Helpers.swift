//
//  CGFloat+Helpers.swift
//  Mathic
//
//  Created by Zakk Hoyt on 5/2/20.
//  Copyright © 2020 Zakk Hoyt. All rights reserved.
//

import CoreGraphics
import Foundation

extension FloatingPoint {
    /// Maps a value from some input range to some output domain by
    /// taking a percent of the value in the input range and applying it to the output range.
    /// - Parameters:
    ///   - value: The value to map.
    ///   - lowerBoundIn: Input upper bound
    ///   - upperBoundIn: Input lower bound
    ///   - lowerBoundOut: Output lower bound
    ///   - upperBoundOut: Output upper bound
    /// - Returns: The projected value
    public static func project(
        value: Self,
        lowerBoundIn: Self,
        upperBoundIn: Self,
        lowerBoundOut: Self,
        upperBoundOut: Self
    ) -> Self {
        let inDelta = upperBoundIn - lowerBoundIn
        let inPercentage = (value - lowerBoundIn) / inDelta
        let outDelta = upperBoundOut - lowerBoundOut
        let outValue = lowerBoundOut + (inPercentage * outDelta)
        return outValue
    }

    public static func interpolate(
        percent: Self,
        lower: Self,
        upper: Self
    ) -> Self {
        lower + percent * (upper - lower)
    }
}

extension ClosedRange where Bound: FloatingPoint {
    public var delta: Bound { upperBound - lowerBound }

    public func percentage(value: Bound) -> Bound {
        (value - lowerBound) / delta
    }
}

extension ClosedRange where Bound: FloatingPoint {
    public static func interpolate<T: FloatingPoint>(
        percent: T,
        minimum: T,
        maximum: T
    ) -> T {
        minimum + percent * (maximum - minimum)
    }
}
