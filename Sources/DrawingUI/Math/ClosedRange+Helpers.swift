//
//  File.swift
//  
//
//  Created by Zakk Hoyt on 2/23/24.
//

import Foundation

extension ClosedRange where Bound: BinaryFloatingPoint {
    /// An alias for `0.0...1.0`
    public static var unit: Self { 0.0...1.0 }
}

// NICE2HAVE: zakkhoyt - rename percent to portion when working with 0.0 ... 1.0

/// When working with ClosedRanges, these 3 names/concepts:
/// 1) `range` denotes a `ClosedRange` of any `T`
/// 2) `percent` is some floating point "unit" value (between 0.0 and 1.0)
/// 3) `value`is some number in the range
/// These 3 as value and percent can be computed from the other (and the range)
/// 4) `span` denotes the range's `upperBound - lowerBound`
extension ClosedRange where Bound: BinaryFloatingPoint {
    @available(*, unavailable, renamed: "span")
    public var delta: Bound { upperBound - lowerBound }
    
    /// Represents the span (or size) `upperBound - lowerBound`
    public var span: Bound { upperBound - lowerBound }
    
    /// Computes a value's precentage through `self`
    ///
    /// ## Example
    ///
    /// ```swift
    /// // returns 0.5
    /// (0.0 ... 5.0).percent(value: 2.5)
    /// ```
    public func percent(
        value: Bound
    ) -> Bound {
        (value - lowerBound) / span
    }

    /// Computes the value at some percent of the size of a `ClosedRange`
    ///
    /// ## Example
    ///
    /// ```swift
    /// (2.0 ... 4.0).value(percent: 0.5) // 3.0
    /// ```
    public func interpolate(
        percent: Bound
    ) -> Bound {
        lowerBound + percent * span
    }
}

extension BinaryFloatingPoint {
    /// Computes a value's precentage through `self`
    ///
    /// ## Example
    ///
    /// ```swift
    /// // returns 0.5
    /// 2.5.percent(range: (0.0 ... 5.0))
    /// ```
    public func percent(
        range: ClosedRange<Self>
    ) -> Self {
        range.percent(value: self)
    }
    
    /// Computes the value from some percent (`self`) of the `ClosedRange` span.
    ///
    /// ## Example
    ///
    /// ```swift
    /// (2.0 ... 4.0).value(percent: 0.5) // 3.0
    /// ```

    public func interpolate(
        range: ClosedRange<Self>
    ) -> Self {
        range.interpolate(percent: self)
    }
}

extension ClosedRange where Bound: BinaryFloatingPoint {
    public static func interpolate<T: BinaryFloatingPoint>(
        percent: T,
        minimum: T,
        maximum: T
    ) -> T {
        (minimum...maximum).interpolate(percent: percent)
    }
}
