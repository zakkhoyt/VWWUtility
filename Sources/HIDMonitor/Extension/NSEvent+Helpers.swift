//
//  NSEvent+Helpers.swift
//  HotkeyDecorator
//
//  Created by Zakk Hoyt on 1/31/24.
//

#if os(macOS)
    import AppKit
    import Foundation

    extension NSEvent.EventTypeMask {
        /// Converts a `NSEvent.EventType` (`enum UInt`) to
        /// `NSEvent.EventTypeMask` (`OptionSet<UInt64>`) by bit shifting the rawValue
        /// (typically by some power of 2).
        public init(eventType: NSEvent.EventType) {
            self.init(eventTypes: [eventType])
        }
    
        /// Converts an array `NSEvent.EventType` (`enum UInt`) to
        /// `NSEvent.EventTypeMask` (`OptionSet<UInt64>`) by bit shifting the rawValue
        /// (typically by some power of 2).
        ///
        /// - SeeAlso: `NSEvent.EventType.maskBit`
        public init(eventTypes: [NSEvent.EventType]) {
            self = NSEvent.EventTypeMask(
                rawValue: eventTypes.map { $0.maskBit }.reduce(0, |)
            )
        }
    }

    extension NSEvent.EventType {
        #warning("FIXME: zakkhoyt - Write code to check this assumption. See CGEventType to CGEventMask for analog")
        /// Math/value used when Apple's private APIs convert
        /// * From: `NSEvent.EventType` (`enum: UInt`)
        /// * To: `NSEvent.EventTypeMask` (`OptionSet<UInt64>`)
        ///
        /// - ToDo: @zakkhoyt Write tests to check this assumption.
        /// - Warning: This math assumption has not been validated.
        /// See `CGEventType` to `CGEventMask` conversion for an example.
        var maskBit: UInt64 {
            1 << rawValue
        }
    }

    extension NSEvent.EventType: CustomStringConvertible, CustomDebugStringConvertible {
        public var description: String {
            switch self {
            case .leftMouseDown: "leftMouseDown"
            case .leftMouseUp: "leftMouseUp"
            case .rightMouseDown: "rightMouseDown"
            case .rightMouseUp: "rightMouseUp"
            case .mouseMoved: "mouseMoved"
            case .leftMouseDragged: "leftMouseDragged"
            case .rightMouseDragged: "rightMouseDragged"
            case .mouseEntered: "mouseEntered"
            case .mouseExited: "mouseExited"
            case .keyDown: "keyDown"
            case .keyUp: "keyUp"
            case .flagsChanged: "flagsChanged"
            case .appKitDefined: "appKitDefined"
            case .systemDefined: "systemDefined"
            case .applicationDefined: "applicationDefined"
            case .periodic: "periodic"
            case .cursorUpdate: "cursorUpdate"
            case .scrollWheel: "scrollWheel"
            case .tabletPoint: "tabletPoint"
            case .tabletProximity: "tabletProximity"
            case .otherMouseDown: "otherMouseDown"
            case .otherMouseUp: "otherMouseUp"
            case .otherMouseDragged: "otherMouseDragged"
            case .gesture: "gesture"
            case .magnify: "magnify"
            case .swipe: "swipe"
            case .rotate: "rotate"
            case .beginGesture: "beginGesture"
            case .endGesture: "endGesture"
            case .smartMagnify: "smartMagnify"
            case .quickLook: "quickLook"
            case .pressure: "pressure"
            case .directTouch: "directTouch"
            case .changeMode: "changeMode"
            @unknown default: "@unknown default"
            }
        }
    
        public var debugDescription: String {
            "\(description) \(rawValue.hexString) \(rawValue) \(rawValue.binaryString)"
        }
    }
#endif
