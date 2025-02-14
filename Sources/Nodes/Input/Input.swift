//
// Input.swift
//
// Created by Zakk Hoyt on 6/20/23.
//

import Foundation

public protocol InputRepresentable {
    associatedtype T
    #warning("FIXME: @zakkhoyt how to better rep and enforce literal vs varaiable input value?")
    var value: T { get set }
    var name: String { get }
    var isEnabled: Bool { get set }
}

public struct Input<T>: InputRepresentable {
    public init(
        name: String,
        value: T,
        isEnabled: Bool = true
    ) {
        self.name = name
        self.value = value
        self.isEnabled = isEnabled
    }
    
    public let name: String
    public var value: T
    public var isEnabled: Bool
}
