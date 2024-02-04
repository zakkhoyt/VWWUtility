//
//  HammerspoonEventTap.swift
//  HotkeyDecorator
//
//  Created by Zakk Hoyt on 1/31/24.
//

import AppKit
import Foundation

extension NSEvent.EventType {
    var maskBit: UInt64 {
        1 << rawValue
    }
}

extension NSEvent.EventTypeMask {
    /// Converts a `CGEventType` (`UInt32`) to
    /// `CGEventMask` (`UInt64`) by bit shifting the rawValue
    /// (typically by some power of 2).
    ///
    /// - Note: Obj-C provides a macro for this (``CGEventMaskBit``)
    /// which doesn't seem to be available in Swift.
    public init(eventType: NSEvent.EventType) {
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
    public init(eventTypes: [NSEvent.EventType]) {
        self = NSEvent.EventTypeMask(
            rawValue: eventTypes.map { $0.maskBit }.reduce(0, |)
        )
    }
}

#warning("FIXME: allEvents, descriptoin, debugDescription")
