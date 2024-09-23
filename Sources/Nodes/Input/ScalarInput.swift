//
// ScalarInput.swift
//
// Created by Zakk Hoyt on 6/20/23.
//

import Foundation

/// Builds on top of `InputRepresentable` where
///  * `value` type `T` is `Numeric` and `Comparable`.
///  * Clamps `value` between a `minValue` and `maxValue`.
///  * Adds an optional `stride` divisor. When value is changed, it will be rounded to the nearest `stride`.
public protocol ScalarInputRepresentable: InputRepresentable where T: Numeric, T: Comparable {
    var minValue: T { get }
    var maxValue: T { get }
    var stride: T? { get }
}

public struct ScalarInput<T: Numeric & Comparable>: ScalarInputRepresentable {
    public typealias DaType = T
    
    public init(
        name: String,
        minValue: T,
        maxValue: T,
        value: T,
        stride: T? = nil,
        isEnabled: Bool = true
    ) {
        self.name = name
        self.minValue = minValue
        self.maxValue = maxValue
        self.value = value
        self.stride = stride
        self.isEnabled = isEnabled
    }
    
    public let name: String
    public let minValue: T
    public let maxValue: T
    public var value: T {
        didSet {
            value = max(min(maxValue, value), minValue)
            #warning("FIXME: @zakkhoyt: Apply stride, if defined")
        }
    }

    public let stride: T?
    public var isEnabled: Bool
}
