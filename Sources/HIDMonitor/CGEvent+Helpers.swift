//
//  HammerspoonEventTap.swift
//  HotkeyDecorator
//
//  Created by Zakk Hoyt on 1/31/24.
//

import CoreGraphics
import Foundation

extension CGEventMask {
    /// Converts a `CGEventType` (`UInt32`) to
    /// `CGEventMask` (`UInt64`) by bit shifting the rawValue
    /// (typically by some power of 2).
    ///
    /// - Note: Obj-C provides a macro for this (``CGEventMaskBit``)
    /// which doesn't seem to be available in Swift.
    public init(eventType: CGEventType) {
        self.init(eventTypes: [eventType])
    }

    /// Converts an array of `CGEventType` (`UInt32`) to
    /// `CGEventMask` (`UInt64`). Each element is bit shifted
    /// (typically by some power of 2), then they are all bitwise OR'd
    /// together.
    ///
    /// - Note: Obj-C provides a macro for this (``CGEventMaskBit``)
    /// which doesn't seem to be available in Swift.
    /// - SeeAlso: `CGEvent.eventBitMask`
    public init(eventTypes: [CGEventType]) {
        self = CGEventMask(
            eventTypes.map { $0.maskBit }.reduce(0, |)
        )
    }
    
    /// Equivalent to `kCGEventMaskForAllEvents`
    ///
    /// - Note: Obj-C provides a static property (`kCGEventMaskForAllEvents`)
    /// which doesn't seem to be available in Swift.
    static let allEvents = CGEventMask(UInt64.max)
}

extension CGEventType {
    var maskBit: UInt32 {
        switch self {
        case .null: 0
        case .leftMouseDown: 1 << 1
        case .leftMouseUp: 1 << 2
        case .rightMouseDown: 1 << 3
        case .rightMouseUp: 1 << 4
        case .mouseMoved: 1 << 5
        case .leftMouseDragged: 1 << 6
        case .rightMouseDragged: 1 << 7
        case .keyDown: 1 << 10
        case .keyUp: 1 << 11
        case .flagsChanged: 1 << 12
        case .scrollWheel: 1 << 22
        case .tabletPointer: 1 << 23
        case .tabletProximity: 1 << 24
        case .otherMouseDown: 1 << 25
        case .otherMouseUp: 1 << 26
        case .otherMouseDragged: 1 << 27
        case .tapDisabledByTimeout: 0xFFFFFFFE
        case .tapDisabledByUserInput: 0xFFFFFFFF
        @unknown default: 0
        }
    }
}

extension CGEventType: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        switch self {
        case .null: "null"
        case .leftMouseDown: "leftMouseDown"
        case .leftMouseUp: "leftMouseUp"
        case .rightMouseDown: "rightMouseDown"
        case .rightMouseUp: "rightMouseUp"
        case .mouseMoved: "mouseMoved"
        case .leftMouseDragged: "leftMouseDragged"
        case .rightMouseDragged: "rightMouseDragged"
        case .keyDown: "keyDown"
        case .keyUp: "keyUp"
        case .flagsChanged: "flagsChanged"
        case .scrollWheel: "scrollWheel"
        case .tabletPointer: "tabletPointer"
        case .tabletProximity: "tabletProximity"
        case .otherMouseDown: "otherMouseDown"
        case .otherMouseUp: "otherMouseUp"
        case .otherMouseDragged: "otherMouseDragged"
        case .tapDisabledByTimeout: "tapDisabledByTimeout"
        case .tapDisabledByUserInput: "tapDisabledByUserInput"
        @unknown default: "@unknown default"
        }
    }
    
    public var debugDescription: String {
        "\(description) (\(rawValue) (\(rawValue.binaryString)"
    }
}
