//
//  HIDCGEventListener.swift
//
//
//  Created by Zakk Hoyt on 6/9/24.
//

import AppKit

// import BaseUtility
import CoreGraphics
import Foundation

/// From Hammerspoon code
///
/// # To observe keystrokes (libeventtap.m)
///
/// ```c
/// // See Hammerspoon source file: libeventtap.m
/// static int eventtap_start(lua_State* L)
///
/// // which instantiates
/// CGEventTapCreate()
/// // And callback function
/// CGEventRef eventtap_callback(CGEventTapProxy proxy, CGEventType type, CGEventRef event, void *refcon) {
/// ```
/// # References
/// * [CGEventTapCreate](https://developer.apple.com/documentation/coregraphics/1454426-cgeventtapcreate?language=objc)
/// * [CGEventTapCallback](https://developer.apple.com/documentation/coregraphics/cgeventtapcallback)
///
/// # To create keystrokes (libeventtap.m)
///
/// ```c
/// // See hammerspoon source file: libeventtap.m
/// static int eventtap_keyStrokes(lua_State* L)
///
/// // which instantiates
/// CGEventRef keyDownEvent = CGEventCreateKeyboardEvent(nil, 0, true);
/// CGEventRef keyUpEvent = CGEventCreateKeyboardEvent(nil, 0, false);
/// CGEventPostToPSN(&psn, keyUpEvent);
/// // (and a few more like this)
/// ```
/// # References
/// * [CGEventCreateKeyboardEvent](https://developer.apple.com/documentation/coregraphics/1456564-cgeventcreatekeyboardevent?language=objc)
///
public class HIDCGEventListener {
    private class Context {
        var tap: CFMachPort?
        var runLoop: CFRunLoopSource?
    }
    
    private var context = Context()
    private var nsEventCallback: (NSEvent) -> NSEvent? = { _ in nil }
    private var cgEventCallback: (CGEvent) -> CGEvent? = { _ in nil }
    private var eventCallback: (String) -> Void = { _ in }
    
    public init() {
        logger.debug("HIDCGEventListener.init()")
    }
    
    public func start(
        //        mask: [Keyboard.Event],
//        scope: HIDEventScope,
        // handler: @escaping (NSEvent) -> NSEvent?
//        handler: @escaping (CGEvent) -> CGEvent?
        handler: @escaping (String) -> Void
    ) throws {
//        nsEventCallback = handler
//        cgEventCallback = handler
        logger.debug("HIDCGEventListener.start")
        eventCallback = handler
        try startEventTapIfNeeded()
    }
    
    public func stop() {
        nsEventCallback = { _ in nil }
        
        if let runLoop = context.runLoop {
            logger.debug("Will remove tap from runloop")
            CFRunLoopRemoveSource(CFRunLoopGetMain(), runLoop, .commonModes)
            context.runLoop = nil
            logger.debug("Did remove tap from runloop")
        }
        if let tap = context.tap {
            logger.debug("Will disable tap")
            CGEvent.tapEnable(tap: tap, enable: false)
            context.tap = nil
            logger.debug("Did disable tap")
        }
    }
    
    // MARK: - Private functions
    
    /// ## References
    ///
    /// * [CGEventType](https://developer.apple.com/documentation/coregraphics/cgeventtype)
    /// * [CGEventMask](https://developer.apple.com/documentation/coregraphics/cgeventmask)
    ///
    private func startEventTapIfNeeded(
        //        mask: [Keyboard.Event],
//        scope: HIDEventScope
    ) throws {
        let tapExistsButIsDisabled = if let tap = context.tap, CGEvent.tapIsEnabled(tap: tap) {
            false
        } else {
            true
        }
        
        guard context.tap == nil || tapExistsButIsDisabled else {
            logger.debug("Event  tap already exists and is already enabled")
            return
        }
        
        // Just in case; don't want dangling ports and loops and such lying around.
        if let runloop = context.runLoop, let tap = context.tap, !CGEvent.tapIsEnabled(tap: tap) {
            logger.debug("Will clean up existing event tap")
            CFMachPortInvalidate(tap)
            CFRunLoopRemoveSource(CFRunLoopGetMain(), runloop, .commonModes)
            logger.debug("Did clean up existing event tap")
        }
        
        logger.debug("Will create new event tap")
        context.tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .listenOnly, // .defaultTap,
            eventsOfInterest: CGEventMask(
                eventTypes: [.keyDown, .keyUp, .flagsChanged]
//                eventTypes: mask.map { $0.cgEventType }
            ),
            callback: { (
                _: CGEventTapProxy,
                _: CGEventType,
                cgEvent: CGEvent,
                userInfoPtr: UnsafeMutableRawPointer?
            ) -> Unmanaged<CGEvent>? in
                
                // Since this is a C callback, it cannot capture swift context.
                // However the `ptr` param points to self (EventTap). We can
                // unwrap it as such then call its functions that way.
                let eventTap = unsafeBitCast(userInfoPtr, to: HIDCGEventListener.self)
                
                //                logger.debug("CGEvent tap callback: \(cgEvent.flags.rawValue.hexString)")
                //                logger.debug("CGEvent tap callback: \(cgEvent.flags.description)")
                
                #warning("TODO: zakkhoyt - Documentation about the audible clunk when this app is focused. Works okay with other apps running. ")
                if let nsEvent = NSEvent(cgEvent: cgEvent) {
                    logger.debug("CGEvent tap callback w/nsEvent: \(nsEvent)")
                    
                    //                    logger.debug("CGEvent tap callback w/nsEvent.modifierFlags: \(nsEvent.modifierFlags.rawValue.hexString)")
                    //                    logger.debug("CGEvent tap callback w/nsEvent.modifierFlags: \(nsEvent.modifierFlags.description)")
                    
                    if let outputNSEvent = eventTap.processNSEvent(nsEvent),
                       let outputCGEvent = outputNSEvent.cgEvent {
                        //                        let outputCGEventPtr = Unmanaged.passUnretained(outputCGEvent)
                        //                        return outputCGEventPtr
                    } else {
                        //                        let outputNSEventPtr = Unmanaged.passUnretained(nsEvent.cgEvent!)
                        //                        return outputNSEventPtr
                    }
                    
                    //                    if NSApplication.shared.isActive {
                    //                        return nil
                    //                    } else {
                    let outputNSEventPtr = Unmanaged.passUnretained(nsEvent.cgEvent!)
                    return outputNSEventPtr
                    //                    }
                } else {
                    logger.debug("CGEvent tap callback w/cgEvent: \(cgEvent.flags.rawValue.hexString)")
                }
                return Unmanaged.passUnretained(cgEvent)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        )
        logger.debug("Did create new event tap")
        
        if let tap = context.tap {
            logger.debug("Will enable tap")
            CGEvent.tapEnable(tap: tap, enable: true)
            logger.debug("Did enable tap")
            
            logger.debug("Will add tap to runloop")
            context.runLoop = CFMachPortCreateRunLoopSource(nil, tap, 0)
            CFRunLoopAddSource(CFRunLoopGetMain(), context.runLoop, .commonModes)
            logger.debug("Did add tap to runloop")
        } else {
            logger.fault("Unable to create event tap. Is Accessibility enabled?")
        }
    }
    
    private func processNSEvent(_ event: NSEvent) -> NSEvent? {
        nsEventCallback(event)
    }
    
    private func processCGEvent(_ event: CGEvent) -> CGEvent? {
        cgEventCallback(event)
    }
}

#if os(macOS)
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
    /// - SeeAlso: `CGEventType.maskBit`
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
    /// Math/value used when Apple's private APIs convert
    /// * from: `CGEventType` (`enum: UInt32`)
    /// * to: `CGEventMask` (`typealias UInt64`)
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
        "\(description) \(rawValue.hexString) \(rawValue) \(rawValue.binaryString)"
    }
}

extension CGEventFlags: CustomStringConvertible, CustomDebugStringConvertible, CaseIterable {
    public static var allCases: [CGEventFlags] {
        [
            .maskAlphaShift,
            .maskShift,
            .maskControl,
            .maskAlternate,
            .maskCommand,
            .maskHelp,
            .maskSecondaryFn,
            .maskNumericPad,
            .maskNonCoalesced
        ]
    }
    
    public var description: String {
        [
            "maskAlphaShift": Self.maskAlphaShift,
            "maskShift": Self.maskShift,
            "maskControl": Self.maskControl,
            "maskAlternate": Self.maskAlternate,
            "maskCommand": Self.maskCommand,
            "maskHelp": Self.maskHelp,
            "maskSecondaryFn": Self.maskSecondaryFn,
            "maskNumericPad": Self.maskNumericPad,
            "maskNonCoalesced": Self.maskNonCoalesced
        ].compactMap {
            self.contains($0.1) ? $0 : nil
        }.map {
            $0.0
        }.sorted().joined(separator: ", ")
    }
    
    public var debugDescription: String {
        description
    }
}

#endif
