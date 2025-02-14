//
// CGFloat+Helpers.swift
// Mathic
//
// Created by Zakk Hoyt on 5/2/20.
// Copyright © 2020 Zakk Hoyt. All rights reserved.
//

import CoreGraphics
import Foundation

extension CGFloat {
    /// Adds or subtracts `2*pi` until  range `lowerBound ..< upperBound` contains `angle`.
    /// - Parameter angle: Input angle
    /// - Parameter into: The range to project `angle` in to.
    /// - Returns: Output angle in the range `0 ..< .tau`
    @available(*, unavailable, renamed: "modulo")
    public static func project(
        angle: CGFloat,
        into range: Range<CGFloat> = (0 * .pi)..<(.tau)
    ) -> CGFloat {
        modulo(angle: angle, into: range)
    }
    
    public static func modulo(
        angle: CGFloat,
        into range: Range<CGFloat> = (0 * .pi)..<(.tau)
    ) -> CGFloat {
        let delta = range.upperBound - range.lowerBound
        
        // A recursive function to move the angle within a certain range
        func adjust(angle: CGFloat) -> CGFloat {
            if angle < range.lowerBound {
                adjust(angle: angle + delta)
            } else if angle >= range.upperBound {
                adjust(angle: angle - delta)
            } else {
                angle
            }
        }
        return adjust(angle: angle)
    }
    
    /// Returns angle (in radians) of a line between two points
    /// - Parameters:
    ///   - point0: first point in a line
    ///   - point1: second point in a line
    /// - Returns: Angle (in radians) of a line between two points and in terms of 0 ... .tau
    public static func angle(point0: CGPoint, point1: CGPoint) -> CGFloat {
        .modulo(
            angle: atan2(
                point1.y - point0.y,
                point1.x - point0.x
            )
        )
    }
    
    /// Assuming that `self` is an angle given in radians
    /// normal is that `self + 1 / .tau` in terms of `0 ..< .tau`
    public var normal0: CGFloat {
        .modulo(
            angle: .modulo(angle: self + 1 / .tau)
        )
    }
    
    public var normal1: CGFloat {
        .modulo(
            angle: .modulo(angle: self - 1 / .tau)
        )
    }
}

extension FloatingPoint {
    @available(*, unavailable, renamed: "contract(max:)", message: "yep, renamed")
    public func percent(
        of max: Self
    ) -> Self {
        contract(max: max)
    }
    
    public func contract(
        max: Self
    ) -> Self {
        self / max
    }
    
    public func expand(
        max: Self
    ) -> Self {
        self * max
    }
}

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
#warning("FIXME: zakkhoyt - Clean up or revert")
        let legacy = lower + percent * (upper - lower)
                
        let new = Self.project(
            value: percent,
            lowerBoundIn: lower,
            upperBoundIn: upper,
            lowerBoundOut: lower,
            upperBoundOut: upper
        )
        
        assertionFailure("legacy != new")
        
        return new
    }
}
