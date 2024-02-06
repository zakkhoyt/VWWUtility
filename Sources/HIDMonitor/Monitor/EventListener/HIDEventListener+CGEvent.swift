//
//  HammerspoonEventTap.swift
//  HotkeyDecorator
//
//  Created by Zakk Hoyt on 1/31/24.
//
#if os(macOS)
import AppKit
import BaseUtility
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
    
    public init() {}
    
    public func start(
        mask: [EventType],
        scope: HIDEventScope,
        handler: @escaping (NSEvent) -> NSEvent?
    ) throws {
        nsEventCallback = handler
        try startEventTapIfNeeded(mask: mask, scope: scope)
    }
    
    public func stop() {
        nsEventCallback = { _ in nil }
        if let runLoop = context.runLoop  {
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
            options: .listenOnly, // .defaultTap,
            eventsOfInterest: CGEventMask(
                // eventTypes: [.keyDown, .keyUp, .flagsChanged]
                eventTypes: mask.map { $0.cgEventType }
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

                
                #warning("TODO: zakkhoyt - Documentation about the audible clunk when this app is focused. Works okay with other apps running. ")
                if let nsEvent = NSEvent(cgEvent: cgEvent) {
                    logger.debug("CGEvent tap callback w/nsEvent: \(nsEvent)")
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
    
    fileprivate func processNSEvent(_ event: NSEvent) -> NSEvent? {
        nsEventCallback(event)
    }
}
#endif
