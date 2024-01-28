//
// Node.swift
// NodeEditor
//
// Created by Zakk Hoyt on 4/5/23.
//
//
//             |---------|                  |----------|                 |----------|
//             | Freq G  |                  | Delay    |                 | Renderer |
//             |         |                  |          |                 |          |
//             | samples |------------------|samples   |                 |          |
//             |         |                  |   samples|-----------------|samples   |
//             |         |                  |          |                 |          |
//             |         |                  |seconds   |                 |          |
//             |         |                  |          |                 |          |

import Foundation

public protocol Node {
    /// A descriptive name for the Node.
    /// Example: `ColorInverter`, `AmplitudeDoubler`, etc...
    var name: String { get }
    
    /// Describes if the flow of data from `input` to `output` is enabled
    var isEnabled: Bool { get }
    
    #warning(
        """
        FIXME: @zakkhoyt Do we need to have inputs/output here? I think we can use Reflection to gather inputs and outputs without manually managing them.
        """
    )
    var inputs: [any InputRepresentable] { get }
    var outputs: [any OutputRepresentable] { get }
    
    /// Processes the data. Lets data flow from `inputs` into `outputs`
    func process()
}

// public protocol ScalarNode: Node {
//    /// A descriptive name for the Node.
//    /// Example: `ColorInverter`, `AmplitudeDoubler`, etc...
//    var name: String { get }
//
//    /// Describes if the flow of data from `input` to `output` is enabled
//    var isEnabled: Bool { get }
//    var inputs: [any ScalarInputRepresentable] { get }
//    var outputs: [any ScalarOutputRepresentable] { get }
//
//    /// Processes the data. Lets data flow from `inputs` into `outputs`
//    func process()
// }

// #warning("FIXME: @zakkhoyt Should this be its own protocol/obj? or part of Node itself?")
// public protocol Connection {
//    associatedtype T
//    var input: T { get set }
//    var outputs: [T] { get set }
//    var name: String? { get }
// }
