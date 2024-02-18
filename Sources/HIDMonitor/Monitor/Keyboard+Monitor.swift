//
//  Keyboard+Monitor.swift
//  WaveSynthesizerSPM_multiplatform_app
//
//  Created by Zakk Hoyt on 6/23/23.
//

#if os(macOS)
import Combine
import Foundation
import os
import SwiftUI

public enum Keyboard {}

extension Keyboard {
    public class Monitor {
        // MARK: Nested Types

        public enum Error: Swift.Error {
            case noKeyPressMonitor
//            case noGlobalAuthorization
        }
        
        // MARK: Public vars
        
        /// This function is called when a key press (down) event occurs.
        /// - Parameter press: The `Keyboard.Press` instance to process.
        /// - Returns: The implementor should return `true` if the press was responded to. `false` otherwise.
        /// When a value of `false` is returned, the system "clunk" noise will be played (audible alert) and the keypress event
        /// will then be forwarded on to other responders. It is important to return `false` if you expect `cmd+q` to quit the app
        /// for example.
        public var pressDown: (Keyboard.Press) -> Bool = { _ in false }

        /// This function is called when a key press (up) event occurs.
        /// - Parameter press: The `Keyboard.Press` instance to process.
        ///
        /// - Returns: The implementor should return `true` if the press was responded to. `false` otherwise.
        /// When a value of `false` is returned, the system "clunk" noise will be played (audible alert) and the keypress event
        /// will then be forwarded on to other responders. It is important to return `false` if you expect `cmd+q` to quit the app
        /// for example.
        public var pressUp: (Keyboard.Press) -> Bool = { _ in false }
        
        
        public var flagsChanged: (Keyboard.Press) -> Bool = { _ in false }

        /// This set keeps track of which keys are down and which have been released.
        /// This will smooth out key repeat events (liek holding a key down).
        public private(set) var activePresses: Set<Keyboard.Press> = [] {
            didSet {
                publicActivePresses = activePresses
            }
        }
        
        @Published
        public private(set) var publicActivePresses: Set<Keyboard.Press> = []
        
        // MARK: Private vars
        
        private var captureType = HIDEventListenerType.noListen
        private var nsEventListener: HIDNSEventListener?
        private var cgEventListener: HIDCGEventListener?
        
        // MARK: Inits
        
        public init() {}
        
        // MARK: Public functions
        
        /// Starts listening for keypress events (keyDown and keyUp events).
        /// - Throws: `Keyboard.Monitor.Error` on failure to begin monitoring.
        public func start(
            captureType: HIDEventListenerType
        ) throws {
            self.captureType = captureType
            switch captureType {
            case .noListen:
                break
            case .nsEventListener(let mask, let scope):
                let monitor: HIDNSEventListener = {
                    guard let nsEventListener = self.nsEventListener else {
                        let nsEventListener = HIDNSEventListener()
                        self.nsEventListener = nsEventListener
                        return nsEventListener
                    }
                    nsEventListener.stop()
                    return nsEventListener
                }()
                try monitor.start(mask: mask, scope: scope) { [weak self] event in
                    guard let self else { return event }
                    let filteredEvent = keyPress(event: event)
                    switch scope {
                    case .local: return filteredEvent
                    case .global: return event
                    case .localAndGlobal: return filteredEvent
                    }
                }

            case .cgEventListener(let mask, let scope):
                let monitor: HIDCGEventListener = {
                    guard let cgEventListener = self.cgEventListener else {
                        let cgEventListener = HIDCGEventListener()
                        self.cgEventListener = cgEventListener
                        return cgEventListener
                    }
                    cgEventListener.stop()
                    return cgEventListener
                }()
                try monitor.start(mask: mask, scope: scope) { [weak self] event in
                    guard let self else { return event }
                    let filteredEvent = keyPress(event: event)
                    switch scope {
                    case .local: return filteredEvent
                    case .global: return event
                    case .localAndGlobal: return filteredEvent
                    }
                }
            }
        }
        
        public func stop() {
            switch captureType {
            case .noListen:
                break
            case .nsEventListener:
                nsEventListener?.stop()
            case .cgEventListener:
                cgEventListener?.stop()
            }
        }
        
        // MARK: Private functions
        
        private func keyPress(event: NSEvent) -> NSEvent? {
            guard let press = try? Keyboard.Press(nsEvent: event) else {
                // Key or Event is some value that we don't support. No real error to handle here.
                return event
            }
            
            switch press.event {
            case .keyDown:
                    
//                // Ignores repeat key down events (holding a key down).zxc
//                // See if activePresses already contains the keypress event (masking out repeat events when holding the key down).
//                guard !activePresses.contains(press) else {
//                    return nil
//                }
//                
//                // This configuration ignores repeat "clunk" on keys we don't handle. Only the first clunk will be heard.
//                // If you wish for repeat events to also clunk then move this line after the guard statement.
//                activePresses.insert(press)
//                guard pressDown(press) else {
//                    logger.debug("pressDown (ignored): \(press.description, privacy: .public)")
//                    return event
//                }
//                logger.debug("pressDown (processed): \(press.description, privacy: .public)")
//                return nil
                logger.debug("pressDown (processed): \(press.description, privacy: .public)")
                return pressDown(press) ? nil : event
                
            case .keyUp:
//                guard activePresses.contains(press) else {
//                    return event
//                }
//                activePresses.remove(press)
//                return pressUp(press) ? nil : event
                logger.debug("pressUp (processed): \(press.description, privacy: .public)")
                return pressDown(press) ? nil : event
                
            case .flagsChanged:
//                #warning("FIXME: zakkhoyt - handle this event")
//                /return event
                logger.debug("flagsChanged (processed): \(press.description, privacy: .public)")
                return flagsChanged(press) ? nil : event
            }
        }
    }
}
#endif
