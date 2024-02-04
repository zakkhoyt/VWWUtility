//
//  File.swift
//  
//
//  Created by Zakk Hoyt on 2/3/24.
//

import AppKit
import Foundation

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
    
    //    case null = 0                             // CGOnly
    //    case mouseEntered = 8                     // NS only
    //    case mouseExited = 9                      // NS only
    //    case appKitDefined = 13                   // NS only
    //    case systemDefined = 14                   // NS only
    //    case applicationDefined = 15              // NS only
    //    case periodic = 16                        // NS only
    //    case cursorUpdate = 17                    // NS only
    //    case tapDisabledByTimeout = 0xFFFFFFFE    // CGOnly
    //    case tapDisabledByUserInput = 0xFFFFFFFF  // CGOnly
     
    var nsEventType: NSEvent.EventType {
        guard let eventType = NSEvent.EventType(rawValue: UInt(rawValue)) else {
            preconditionFailure("Failed to cast EventType to NSEvent.EventType")
        }
        return eventType
    }
    
    var cgEventType: CGEventType {
        //guard let eventType = NSEvent.EventType(rawValue: UInt(rawValue)) else {
        guard let eventType = CGEventType(rawValue: rawValue) else {
            preconditionFailure("Failed to cast EventType to CGEventType")
        }
        return eventType
    }
 
    #warning("FIXME: zakkhoyt - Handle collection for NS and CG cases. ")
//    var cgEventMask: CGEventMask {
//        CGEventMask(eventType: cgEventType)
//    }
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
        mask: NSEvent.EventTypeMask,
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
        mask: CGEventMask,
        scope: HIDEventScope
    )
}
