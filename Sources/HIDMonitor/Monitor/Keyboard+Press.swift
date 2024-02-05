//
//  Keyboard+Press.swift
//  WaveSynthesizerSPM_multiplatform_app
//
//  Created by Zakk Hoyt on 6/23/23.
//

#if os(macOS)
import AppKit
import Foundation

extension Keyboard {
    public struct Press {
        // MARK: Public vars
        
        public let event: Event
        public let key: Key
        public let flags: Set<Flag>

        // MARK: Inits
        
        init(
            nsEvent: NSEvent
        ) throws {
            self.event = try Event(nsEvent: nsEvent)
            self.key = try Key(nsEvent: nsEvent)
            self.flags = Flag.flags(nsEvent: nsEvent)
        }
    }
}

extension Keyboard.Press: CustomStringConvertible {
    public var description: String {
        let flagsDescription: String = {
            guard !flags.isEmpty else { return "" }
            return flags.map { $0.description }.description

        }()
        return [flagsDescription, key.description].joined(separator: " ")
    }
}

extension Keyboard.Press: CustomDebugStringConvertible {
    public var debugDescription: String {
        let flagsDescription: String = {
            guard !flags.isEmpty else { return "" }
            return flags.map { $0.debugDescription }.description

        }()
        return [flagsDescription, key.debugDescription].joined(separator: " ")
    }
}

extension Keyboard.Press: KeyboardKeyRepresentable {
    public var symbol: String {
        let flagSymbols: String = {
            guard !flags.isEmpty else { return "" }
            return flags.map { $0.symbol }.joined(separator: " + ")
            
        }()
        #warning("FIXME: zakkhoyt - Broken when no flags")
        return [flagSymbols, key.symbol].joined(separator: " + ")
    }
    
    public var symbolName: String {
        ""
    }

}

extension Keyboard.Press: Hashable {
    // MARK: Implements Hashable
    
    public func hash(into hasher: inout Hasher) {
        // We are intentionally leaving out `self.event` as it's context, not value
        hasher.combine(key.hashValue)
    }
    
    // MARK: Implements Equatable
    
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.hashValue == rhs.hashValue
    }
}

#endif
