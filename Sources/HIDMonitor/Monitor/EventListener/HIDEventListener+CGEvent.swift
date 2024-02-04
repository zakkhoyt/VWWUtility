//
//  HammerspoonEventTap.swift
//  HotkeyDecorator
//
//  Created by Zakk Hoyt on 1/31/24.
//

import AppKit
import CoreGraphics
import Foundation
import BaseUtility

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
        var fn: Int?
        var mask: CGEvent?
        var tap: CFMachPort?
        var runLoop: CFRunLoopSource?
    }
    
    private var context = Context()
    private var nsEventCallback: (NSEvent) -> NSEvent? = { _ in nil }
    
    public init() {}
    
    public func start(
//        mask: CGEventMask,
        mask: [EventType],
        scope: HIDEventScope,
        handler: @escaping (NSEvent) -> NSEvent?
    ) throws {
        nsEventCallback = handler
        try startEventTapIfNeeded(mask: mask, scope: scope)
    }
    
    public func stop() {
        nsEventCallback = { _ in nil }
        #warning("FIXME: zakkhoyt - Implement stop()")
    }

    // MARK: - Private functions
    
    /// ## References
    ///
    /// * [CGEventType](https://developer.apple.com/documentation/coregraphics/cgeventtype)
    /// * [CGEventMask](https://developer.apple.com/documentation/coregraphics/cgeventmask)
    ///
    private func startEventTapIfNeeded(
        mask: [EventType],
        scope: HIDEventScope
    ) throws {
        let tapExistsButIsDisabled: Bool = {
            if let tap = context.tap, CGEvent.tapIsEnabled(tap: tap) {
                false
            } else {
                true
            }
        }()
        
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
            options: .listenOnly, //.defaultTap,
            eventsOfInterest: CGEventMask(
                //eventTypes: [.keyDown, .keyUp, .flagsChanged]
                eventTypes: mask.map { $0.cgEventType }
            ),
            callback: { (
                tapProxy: CGEventTapProxy,
                cgEventType: CGEventType,
                cgEvent: CGEvent,
                userInfoPtr: UnsafeMutableRawPointer?
            ) -> Unmanaged<CGEvent>? in
                logger.debug("callback")
                // Since this is a C callback, it cannot capture swift context.
                // However the `ptr` param points to self (EventTap). We can
                // unwrap it as such then call its functions that way.
                let eventTap = unsafeBitCast(userInfoPtr, to: HIDCGEventListener.self)

#warning("TODO: zakkhoyt - Documentation about the audible clunk when this app is focused. Works okay with other apps running. ")
                if let nsEvent = NSEvent(cgEvent: cgEvent) {
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
                    

                }
                return Unmanaged.passUnretained(cgEvent)
            },
            userInfo: Unmanaged.passUnretained(self).toOpaque()
        )
        logger.debug("Did create new event tap")
        
        if let tap = context.tap {
            logger.debug("Will add tap to runloop")
            CGEvent.tapEnable(tap: tap, enable: true)
            context.runLoop = CFMachPortCreateRunLoopSource(nil, tap, 0)
            CFRunLoopAddSource(CFRunLoopGetMain(), context.runLoop, .commonModes)
            logger.debug("Did add tap to runloop")
        } else {
            logger.fault("Unable to create event tap. Is Accessibility enabled?")
        }
    }
    
    fileprivate func processNSEvent(_ event: NSEvent) -> NSEvent? {
        nsEventCallback(event)
    }
}
