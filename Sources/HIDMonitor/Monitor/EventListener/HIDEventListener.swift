//
//  File.swift
//  
//
//  Created by Zakk Hoyt on 2/3/24.
//

import AppKit
import CoreGraphics
import Foundation



/// ## Example
///
/// ```swift
/// // enum  UInt32
/// let a: CGEventType = .keyDown
///
/// // typealias UIInt64
/// let b: CGEventMask! = CGEventMask
///
/// // enum  UInt
/// let c: NSEvent.EventType! = .keyDown
///
/// // struct OptionSet<UInt64>. init(NSEvent.EventType)
/// let d: NSEvent.EventTypeMask!
/// ```
public enum EventType: UInt32, CaseIterable {
    case leftMouseDown = 1
    case leftMouseUp = 2
    case rightMouseDown = 3
    case rightMouseUp = 4
    case mouseMoved = 5
    case leftMouseDragged = 6
    case rightMouseDragged = 7

    case keyDown = 10
    case keyUp = 11
    case flagsChanged = 12
    
    case scrollWheel = 22
    case tabletPointer = 23
    case tabletProximity = 24
    case otherMouseDown = 25
    case otherMouseUp = 26
    case otherMouseDragged = 27
    
    #warning("FIXME: zakkhoyt - Evaluate the 2 mask types as well")
    
    
    //    case null = 0                             // CGEventType Only
    //    case mouseEntered = 8                     // NSEvent.EventType only
    //    case mouseExited = 9                      // NSEvent.EventType only
    //    case appKitDefined = 13                   // NSEvent.EventType only
    //    case systemDefined = 14                   // NSEvent.EventType only
    //    case applicationDefined = 15              // NSEvent.EventType only
    //    case periodic = 16                        // NSEvent.EventType only
    //    case cursorUpdate = 17                    // NSEvent.EventType only
    //    case tapDisabledByTimeout = 0xFFFFFFFE    // CGEventType Only
    //    case tapDisabledByUserInput = 0xFFFFFFFF  // CGEventType Only
     
#warning("FIXME: zakkhoyt - Add tests for all 4 below and array variants")
    var cgEventType: CGEventType {
        //guard let eventType = NSEvent.EventType(rawValue: UInt(rawValue)) else {
        //guard let eventType = CGEventType(rawValue: rawValue) else {
        guard let eventType = CGEventType(rawValue: CGEventType.RawValue.init(rawValue)) else {
            preconditionFailure("Failed to cast EventType to CGEventType")
        }
        return eventType
    }

    var nsEventType: NSEvent.EventType {
//        guard let eventType = NSEvent.EventType(rawValue: UInt(rawValue)) else {
        guard let eventType = NSEvent.EventType(rawValue: NSEvent.EventType.RawValue.init(rawValue)) else {
            preconditionFailure("Failed to cast EventType to NSEvent.EventType")
        }
        return eventType
    }
    
    var cgEventMask: CGEventMask {
        CGEventMask(eventType: cgEventType)
    }

    var nsEventTypeMask: NSEvent.EventTypeMask {
        NSEvent.EventTypeMask(rawValue: UInt64(rawValue))
    }
}

extension Collection where Element == EventType {
    var cgEventMask: CGEventMask {
        CGEventMask(eventTypes: map { $0.cgEventType })
    }

    var nsEventMask: NSEvent.EventTypeMask {
//        NSEvent.EventTypeMask(
//            rawValue: map { 1 << $0.rawValue }.reduce(0, |)
//        )
        NSEvent.EventTypeMask(eventTypes: map { $0.nsEventType })
    }
}




public enum HIDEventScope: CaseIterable {
    case local
    case global
    case localAndGlobal
}

#warning("FIXME: zakkhoyt - wrap eventmask types")

public enum HIDEventListenerType {
    case noListen
    
    /// ## Example
    ///
    /// ```swift
    /// try keyboardMonitor.start(
    ///     captureType: .nsEventListener(
    ///         mask: [.keyDown, .keyUp, .flagsChanged],
    ///         scope: .local
    ///     )
    /// )
    /// ```
    case nsEventListener(
//        mask: NSEvent.EventTypeMask,
//        mask: Set<EventType>,
        mask: [EventType],
        scope: HIDEventScope
    )
    

    /// ## Example
    ///
    /// ```swift
    /// try keyboardMonitor.start(
    ///     captureType: .cgEventListener(
    ///         mask: CGEventMask(eventTypes: [.keyDown, .keyUp, .flagsChanged]),
    ///         scope: .global
    ///     )
    /// )
    /// ```
    case cgEventListener(
//        mask: CGEventMask,
//        mask: Set<EventType>,
        mask: [EventType],
        scope: HIDEventScope
    )
}
