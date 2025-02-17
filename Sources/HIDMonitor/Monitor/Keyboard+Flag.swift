//
// Keyboard+Flag.swift
// WaveSynthesizerSPM_multiplatform_app
//
// Created by Zakk Hoyt on 6/23/23.
//

#if os(macOS)
import AppKit
import SwiftUI

extension Keyboard {
    public enum Flag: CaseIterable {
        case capsLock
        case shift
        case control
        case option
        case command
        case numericPad
        case help
        case function
        case deviceIndependentFlagsMask

        // MARK: - Computed Properties
         
        var modifierFlags: NSEvent.ModifierFlags {
            switch self {
            case .capsLock: .capsLock
            case .shift: .shift
            case .control: .control
            case .option: .option
            case .command: .command
            case .numericPad: .numericPad
            case .help: .help
            case .function: .function
            case .deviceIndependentFlagsMask: .deviceIndependentFlagsMask
            }
        }
        
        // MARK: - Static functions
        
        static func flags(
            modifierFlags: NSEvent.ModifierFlags
        ) -> Set<Flag> {
            Set<Keyboard.Flag>(
                Keyboard.Flag
                    .allCases
                    .filter { modifierFlags.contains($0.modifierFlags) }
            )
        }
        
        static func flags(
            nsEvent: NSEvent
        ) -> Set<Flag> {
            flags(modifierFlags: nsEvent.modifierFlags)
        }
    }
}

// MARK: - Implements CustomStringConvertible

extension Keyboard.Flag: CustomStringConvertible {
    public var description: String {
        switch self {
        case .capsLock: "⇪"
        case .command: "⌘"
        case .control: "⌃"
        case .deviceIndependentFlagsMask: "deviceIndependentFlagsMask"
        case .function: "🌐"
        case .help: "help"
        case .numericPad: "numericPad"
        case .option: "⌥"
        case .shift: "⇧"
        }
    }
}

extension Keyboard.Flag: KeyboardKeyRepresentable {
    /// Taken from `SF Symbols.app`
    public var symbol: String {
        switch self {
        case .capsLock: "􀆡"
        case .command: "􀆔"
        case .control: "􀆍"
        case .deviceIndependentFlagsMask: "􀋉"
        case .function: "􀆪" // 􀥌
        case .help: "􀁜"
        case .numericPad: "􀃪"
        case .option: "􀆕"
        case .shift: "􀆝"
        }
    }
    
    public var symbolName: String {
        switch self {
        case .capsLock: "capslock"
        case .command: "command"
        case .control: "control"
        case .deviceIndependentFlagsMask: "flag"
        case .function: "globe" // fn
        case .help: "questionmark.circle"
        case .numericPad: "number.square"
        case .option: "option"
        case .shift: "shift"
        }
    }
}

// MARK: - Implements CustomDebugStringConvertible

extension Keyboard.Flag: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .capsLock: "capsLock \(description)"
        case .command: "command \(description)"
        case .control: "control \(description)"
        case .deviceIndependentFlagsMask: "deviceIndependentFlagsMask \(description)"
        case .function: "function \(description)"
        case .help: "help \(description)"
        case .numericPad: "numericPad \(description)"
        case .option: "option \(description)"
        case .shift: "shift \(description)"
        }
    }
}
#endif
