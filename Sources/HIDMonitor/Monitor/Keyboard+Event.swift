//
//  Keyboard+Event.swift
//  WaveSynthesizerSPM_multiplatform_app
//
//  Created by Zakk Hoyt on 6/23/23.
//

#if os(macOS)
import AppKit

extension Keyboard {
    public enum Event: CaseIterable {
        case keyDown
        case keyUp
        
        #warning("FIXME: zakkhoyt - Clones EventType (prefer newer EventType")
        #warning("FIXME: zakkhoyt - Support flagsChanged")
//        case flagsChanged
        
        // MARK: - Nested Types
        
        public enum Error: Swift.Error {
            case unsupportedEventType(NSEvent.EventType)
        }
        
        // MARK: - Inits
        
        init(
            nsEvent: NSEvent
        ) throws {
            guard let keyboardEvent = (
                Keyboard.Event.allCases
                    .filter { $0.eventType == nsEvent.type }
                    .first
            ) else {
                throw Error.unsupportedEventType(nsEvent.type)
            }
            self = keyboardEvent
        }
        
        // MARK: - Public functions
        
        public var eventType: NSEvent.EventType {
            switch self {
            case .keyDown: .keyDown
            case .keyUp: .keyUp
            }
        }
    }
}

// MARK: - Implements CustomDebugStringConvertible

extension Keyboard.Event: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .keyDown: "keyDown"
        case .keyUp: "keyUp"
        }
    }
}
#endif
