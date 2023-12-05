//
//  Output.swift
//
//  Created by Zakk Hoyt on 6/20/23.
//

import Foundation

public protocol OutputRepresentable {
    associatedtype T
    
    /// The current output value, `T`
    var value: T { get }
    
    /// The name of the output.
    var name: String { get }
}

public struct Output<T>: OutputRepresentable {
    public init(
        name: String,
        value: T
    ) {
        self.name = name
        self.value = value
    }
    
    public let name: String
    public var value: T
}
