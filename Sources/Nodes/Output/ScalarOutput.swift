//
//  ScalarOutput.swift
//
//  Created by Zakk Hoyt on 6/20/23.
//

import Foundation

public protocol ScalarOutputRepresentable: OutputRepresentable where T: Numeric, T: Comparable {
    var minValue: T { get }
    var maxValue: T { get }
    var stride: T? { get }
}

public struct ScalarOutput<T: Numeric & Comparable>: ScalarOutputRepresentable {
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
            #warning("FIXME: @zakkhoyt: stride, if enabled")
        }
    }

    public let stride: T?
    public var isEnabled: Bool
}
