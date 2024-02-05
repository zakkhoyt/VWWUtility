//
//  Keyboard+Key.swift
//
//  Created by Zakk Hoyt
//  Copyright © 2023 Zakk Hoyt.
//
//
//  These key code constants are wrappers around Carbon's
//  <HIToolbox/Events.h> header file. This just provides
//  swifty syntax sugar. Think of it as "NSKeyCodes".

#if os(macOS)
import AppKit
import Carbon

extension Keyboard {
    public enum Key: UInt16, Identifiable {
        public var id: UInt16 {
            rawValue
        }

        case a = 0 // Carbon.kVK_ANSI_A
        case b = 11 // Carbon.kVK_ANSI_B
        case c = 8 // Carbon.kVK_ANSI_C
        case d = 2 // Carbon.kVK_ANSI_D
        case context = 14 // Carbon.kVK_ANSI_E
        case f = 3 // Carbon.kVK_ANSI_F
        case g = 5 // Carbon.kVK_ANSI_G
        case h = 4 // Carbon.kVK_ANSI_H
        case i = 34 // Carbon.kVK_ANSI_I
        case j = 38 // Carbon.kVK_ANSI_J
        case k = 40 // Carbon.kVK_ANSI_K
        case l = 37 // Carbon.kVK_ANSI_L
        case m = 46 // Carbon.kVK_ANSI_M
        case n = 45 // Carbon.kVK_ANSI_N
        case o = 31 // Carbon.kVK_ANSI_O
        case p = 35 // Carbon.kVK_ANSI_P
        case q = 12 // Carbon.kVK_ANSI_Q
        case r = 15 // Carbon.kVK_ANSI_R
        case s = 1 // Carbon.kVK_ANSI_S
        case t = 17 // Carbon.kVK_ANSI_T
        case u = 32 // Carbon.kVK_ANSI_U
        case v = 9 // Carbon.kVK_ANSI_V
        case w = 13 // Carbon.kVK_ANSI_W
        case x = 7 // Carbon.kVK_ANSI_X
        case y = 16 // Carbon.kVK_ANSI_Y
        case z = 6 // Carbon.kVK_ANSI_Z
        
        case number0 = 29 // Carbon.kVK_ANSI_0
        case number1 = 18 // Carbon.kVK_ANSI_1
        case number2 = 19 // Carbon.kVK_ANSI_2
        case number3 = 20 // Carbon.kVK_ANSI_3
        case number4 = 21 // Carbon.kVK_ANSI_4
        case number5 = 23 // Carbon.kVK_ANSI_5
        case number6 = 22 // Carbon.kVK_ANSI_6
        case number7 = 26 // Carbon.kVK_ANSI_7
        case number8 = 28 // Carbon.kVK_ANSI_8
        case number9 = 25 // Carbon.kVK_ANSI_9
        
        case keypad0 = 82 // Carbon.kVK_ANSI_Keypad0
        case keypad1 = 83 // Carbon.kVK_ANSI_Keypad1
        case keypad2 = 84 // Carbon.kVK_ANSI_Keypad2
        case keypad3 = 85 // Carbon.kVK_ANSI_Keypad3
        case keypad4 = 86 // Carbon.kVK_ANSI_Keypad4
        case keypad5 = 87 // Carbon.kVK_ANSI_Keypad5
        case keypad6 = 88 // Carbon.kVK_ANSI_Keypad6
        case keypad7 = 89 // Carbon.kVK_ANSI_Keypad7
        case keypad8 = 91 // Carbon.kVK_ANSI_Keypad8
        case keypad9 = 92 // Carbon.kVK_ANSI_Keypad9
        case keypadClear = 71 // Carbon.kVK_ANSI_KeypadClear
        case keypadDivide = 75 // Carbon.kVK_ANSI_KeypadDivide
        case keypadEnter = 76 // Carbon.kVK_ANSI_KeypadEnter
        case keypadEquals = 81 // Carbon.kVK_ANSI_KeypadEquals
        case keypadMinus = 78 // Carbon.kVK_ANSI_KeypadMinus
        case keypadPlus = 69 // Carbon.kVK_ANSI_KeypadPlus
        
        case pageDown = 121 // Carbon.kVK_PageDown
        case pageUp = 116 // Carbon.kVK_PageUp
        case end = 119 // Carbon.kVK_End
        case home = 115 // Carbon.kVK_Home
        
        case f1 = 122 // Carbon.kVK_F1
        case f2 = 120 // Carbon.kVK_F2
        case f3 = 99 // Carbon.kVK_F3
        case f4 = 118 // Carbon.kVK_F4
        case f5 = 96 // Carbon.kVK_F5
        case f6 = 97 // Carbon.kVK_F6
        case f7 = 98 // Carbon.kVK_F7
        case f8 = 100 // Carbon.kVK_F8
        case f9 = 101 // Carbon.kVK_F9
        case f10 = 109 // Carbon.kVK_F10
        case f11 = 103 // Carbon.kVK_F11
        case f12 = 111 // Carbon.kVK_F12
        case f13 = 105 // Carbon.kVK_F13
        case f14 = 107 // Carbon.kVK_F14
        case f15 = 113 // Carbon.kVK_F15
        case f16 = 106 // Carbon.kVK_F16
        case f17 = 64 // Carbon.kVK_F17
        case f18 = 79 // Carbon.kVK_F18
        case f19 = 80 // Carbon.kVK_F19
        case f20 = 90 // Carbon.kVK_F20
        
        case apostrophe = 39 // Carbon.kVK_ANSI_Quote
        case backApostrophe = 50 // Carbon.kVK_ANSI_Grave
        case backslash = 42 // Carbon.kVK_ANSI_Backslash
        case capsLock = 57 // Carbon.kVK_CapsLock
        case comma = 43 // Carbon.kVK_ANSI_Comma
        case help = 114 // Carbon.kVK_Help
        case forwardDelete = 117 // Carbon.kVK_ForwardDelete
        case decimal = 65 // Carbon.kVK_ANSI_KeypadDecimal
        case delete = 51 // Carbon.kVK_Delete
        case equals = 24 // Carbon.kVK_ANSI_Equal
        case escape = 53 // Carbon.kVK_Escape
        case leftBracket = 33 // Carbon.kVK_ANSI_LeftBracket
        case minus = 27 // Carbon.kVK_ANSI_Minus
        case multiply = 67 // Carbon.kVK_ANSI_KeypadMultiply
        case period = 47 // Carbon.kVK_ANSI_Period
        case `return` = 36 // Carbon.kVK_Return
        case rightBracket = 30 // Carbon.kVK_ANSI_RightBracket
        case semicolon = 41 // Carbon.kVK_ANSI_Semicolon
        case slash = 44 // Carbon.kVK_ANSI_Slash
        case space = 49 // Carbon.kVK_Space
        case tab = 48 // Carbon.kVK_Tab
        case mute = 74 // Carbon.kVK_Mute
        case volumeDown = 73 // Carbon.kVK_VolumeDown
        case volumeUp = 72 // Carbon.kVK_VolumeUp
        
        case command = 55 // Carbon.kVK_Command
        case rightCommand = 54 // Carbon.kVK_RightCommand
        case control = 59 // Carbon.kVK_Control
        case rightControl = 62 // Carbon.kVK_RightControl
        case function = 63 // Carbon.kVK_Function
        case option = 58 // Carbon.kVK_Option
        case rightOption = 61 // Carbon.kVK_RightOption
        case shift = 56 // Carbon.kVK_Shift
        case rightShift = 60 // Carbon.kVK_RightShift
        
        case downArrow = 125 // Carbon.kVK_DownArrow
        case leftArrow = 123 // Carbon.kVK_LeftArrow
        case rightArrow = 124 // Carbon.kVK_RightArrow
        case upArrow = 126 // Carbon.kVK_UpArrow
        
        // MARK: - Nested Types
        
        enum Error: Swift.Error {
            case unsupportedKeyCode(UInt16)
        }

        // MARK: - Inits
        
        /// Instantiates a `Keyboard.Key` from an `NSEvent`
        /// Will throw `Error.unsupportedKeyCode` if `nsEvent.keyCode` is an unhandled value.
        ///
        /// - Parameter nsEvent: An `NSEvent` instance (typically obtained the from responder chain)
        init(
            nsEvent: NSEvent
        ) throws {
            guard let key = Key(rawValue: nsEvent.keyCode) else {
                throw Error.unsupportedKeyCode(nsEvent.keyCode)
            }
            self = key
        }
    }
}

// MARK: - Implements CustomStringConvertible

extension Keyboard.Key: CustomStringConvertible {
    public var description: String {
        switch self {
        case .a: "a"
        case .b: "b"
        case .c: "c"
        case .d: "d"
        case .context: "e"
        case .f: "f"
        case .g: "g"
        case .h: "h"
        case .i: "i"
        case .j: "j"
        case .k: "k"
        case .l: "l"
        case .m: "m"
        case .n: "n"
        case .o: "o"
        case .p: "p"
        case .q: "q"
        case .r: "r"
        case .s: "s"
        case .t: "t"
        case .u: "u"
        case .v: "v"
        case .w: "w"
        case .x: "x"
        case .y: "y"
        case .z: "z"
            
        case .number0: "0"
        case .number1: "1"
        case .number2: "2"
        case .number3: "3"
        case .number4: "4"
        case .number5: "5"
        case .number6: "6"
        case .number7: "7"
        case .number8: "8"
        case .number9: "9"
            
        case .keypad0: "0 (keypad)"
        case .keypad1: "1 (keypad)"
        case .keypad2: "2 (keypad)"
        case .keypad3: "3 (keypad)"
        case .keypad4: "4 (keypad)"
        case .keypad5: "5 (keypad)"
        case .keypad6: "6 (keypad)"
        case .keypad7: "7 (keypad)"
        case .keypad8: "8 (keypad)"
        case .keypad9: "9 (keypad)"
        case .keypadClear: "clear (keypad)"
        case .keypadDivide: "divide (keypad)"
        case .keypadEnter: "enter (keypad)"
        case .keypadEquals: "equals (keypad)"
        case .keypadMinus: "minus (keypad)"
        case .keypadPlus: "plus (keypad)"
            
        case .pageDown: "pageDown"
        case .pageUp: "pageUp"
        case .end: "end"
        case .home: "home"
            
        case .f1: "f1"
        case .f2: "f2"
        case .f3: "f3"
        case .f4: "f4"
        case .f5: "f5"
        case .f6: "f6"
        case .f7: "f7"
        case .f8: "f8"
        case .f9: "f9"
        case .f10: "f10"
        case .f11: "f11"
        case .f12: "f12"
        case .f13: "f13"
        case .f14: "f14"
        case .f15: "f15"
        case .f16: "f16"
        case .f17: "f17"
        case .f18: "f18"
        case .f19: "f19"
        case .f20: "f20"
            
        case .apostrophe: "'"
        case .backApostrophe: "`"
        case .backslash: #"\"#
        case .capsLock: "􀆡"
        case .comma: ","
        case .help: "help"
        case .forwardDelete: "􁂒"
        case .decimal: "decimal"
        case .delete: "􁂈"
        case .equals: "􀆀"
        case .escape: "􀆧"
        case .leftBracket: "["
        case .minus: "-"
        case .multiply: "*"
        case .period: "."
        case .return: "􀆎" // 􀅇
        case .rightBracket: "]"
        case .semicolon: ";"
        case .slash: "/"
        case .space: "􁁺"
        case .tab: "􀅂"
        case .mute: "􀊢"
        case .volumeDown: "􀊤"
        case .volumeUp: "􀊨"
            
        case .command: "􀆔"
        case .rightCommand: "􀆔"
        case .control: "􀆍"
        case .rightControl: "􀆍"
        case .function: "􀥌"
        case .option: "􀆕"
        case .rightOption: "􀆕"
        case .shift: "􀆝"
        case .rightShift: "􀆝"
            
        case .downArrow: "􀄩"
        case .leftArrow: "􀄪"
        case .rightArrow: "􀄫"
        case .upArrow: "􀄨"
        }
    }
}

// MARK: - Implements CustomDebugStringConvertible

extension Keyboard.Key: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .a: "\(description) a (Carbon.kVK_ANSI_A: \(rawValue))"
        case .b: "\(description) b (Carbon.kVK_ANSI_B: \(rawValue))"
        case .c: "\(description) c (Carbon.kVK_ANSI_C: \(rawValue))"
        case .d: "\(description) d (Carbon.kVK_ANSI_D: \(rawValue))"
        case .context: "\(description) e (Carbon.kVK_ANSI_E: \(rawValue))"
        case .f: "\(description) f (Carbon.kVK_ANSI_F: \(rawValue))"
        case .g: "\(description) g (Carbon.kVK_ANSI_G: \(rawValue))"
        case .h: "\(description) h (Carbon.kVK_ANSI_H: \(rawValue))"
        case .i: "\(description) i (Carbon.kVK_ANSI_I: \(rawValue))"
        case .j: "\(description) j (Carbon.kVK_ANSI_J: \(rawValue))"
        case .k: "\(description) k (Carbon.kVK_ANSI_K: \(rawValue))"
        case .l: "\(description) l (Carbon.kVK_ANSI_L: \(rawValue))"
        case .m: "\(description) m (Carbon.kVK_ANSI_M: \(rawValue))"
        case .n: "\(description) n (Carbon.kVK_ANSI_N: \(rawValue))"
        case .o: "\(description) o (Carbon.kVK_ANSI_O: \(rawValue))"
        case .p: "\(description) p (Carbon.kVK_ANSI_P: \(rawValue))"
        case .q: "\(description) q (Carbon.kVK_ANSI_Q: \(rawValue))"
        case .r: "\(description) r (Carbon.kVK_ANSI_R: \(rawValue))"
        case .s: "\(description) s (Carbon.kVK_ANSI_S: \(rawValue))"
        case .t: "\(description) t (Carbon.kVK_ANSI_T: \(rawValue))"
        case .u: "\(description) u (Carbon.kVK_ANSI_U: \(rawValue))"
        case .v: "\(description) v (Carbon.kVK_ANSI_V: \(rawValue))"
        case .w: "\(description) w (Carbon.kVK_ANSI_W: \(rawValue))"
        case .x: "\(description) x (Carbon.kVK_ANSI_X: \(rawValue))"
        case .y: "\(description) y (Carbon.kVK_ANSI_Y: \(rawValue))"
        case .z: "\(description) z (Carbon.kVK_ANSI_Z: \(rawValue))"
            
        case .number0: "\(description) number0 (Carbon.kVK_ANSI_0: \(rawValue))"
        case .number1: "\(description) number1 (Carbon.kVK_ANSI_1: \(rawValue))"
        case .number2: "\(description) number2 (Carbon.kVK_ANSI_2: \(rawValue))"
        case .number3: "\(description) number3 (Carbon.kVK_ANSI_3: \(rawValue))"
        case .number4: "\(description) number4 (Carbon.kVK_ANSI_4: \(rawValue))"
        case .number5: "\(description) number5 (Carbon.kVK_ANSI_5: \(rawValue))"
        case .number6: "\(description) number6 (Carbon.kVK_ANSI_6: \(rawValue))"
        case .number7: "\(description) number7 (Carbon.kVK_ANSI_7: \(rawValue))"
        case .number8: "\(description) number8 (Carbon.kVK_ANSI_8: \(rawValue))"
        case .number9: "\(description) number9 (Carbon.kVK_ANSI_9: \(rawValue))"
            
        case .keypad0: "\(description) keypad0 (Carbon.kVK_ANSI_Keypad0: \(rawValue))"
        case .keypad1: "\(description) keypad1 (Carbon.kVK_ANSI_Keypad1: \(rawValue))"
        case .keypad2: "\(description) keypad2 (Carbon.kVK_ANSI_Keypad2: \(rawValue))"
        case .keypad3: "\(description) keypad3 (Carbon.kVK_ANSI_Keypad3: \(rawValue))"
        case .keypad4: "\(description) keypad4 (Carbon.kVK_ANSI_Keypad4: \(rawValue))"
        case .keypad5: "\(description) keypad5 (Carbon.kVK_ANSI_Keypad5: \(rawValue))"
        case .keypad6: "\(description) keypad6 (Carbon.kVK_ANSI_Keypad6: \(rawValue))"
        case .keypad7: "\(description) keypad7 (Carbon.kVK_ANSI_Keypad7: \(rawValue))"
        case .keypad8: "\(description) keypad8 (Carbon.kVK_ANSI_Keypad8: \(rawValue))"
        case .keypad9: "\(description) keypad9 (Carbon.kVK_ANSI_Keypad9: \(rawValue))"
        case .keypadClear: "\(description) keypadClear (Carbon.kVK_ANSI_KeypadClear: \(rawValue))"
        case .keypadDivide: "\(description) keypadDivide (Carbon.kVK_ANSI_KeypadDivide: \(rawValue))"
        case .keypadEnter: "\(description) keypadEnter (Carbon.kVK_ANSI_KeypadEnter: \(rawValue))"
        case .keypadEquals: "\(description) keypadEquals (Carbon.kVK_ANSI_KeypadEquals: \(rawValue))"
        case .keypadMinus: "\(description) keypadMinus (Carbon.kVK_ANSI_KeypadMinus: \(rawValue))"
        case .keypadPlus: "\(description) keypadPlus (Carbon.kVK_ANSI_KeypadPlus: \(rawValue))"
            
        case .pageDown: "\(description) pageDown (Carbon.kVK_PageDown: \(rawValue))"
        case .pageUp: "\(description) pageUp (Carbon.kVK_PageUp: \(rawValue))"
        case .end: "\(description) end (Carbon.kVK_End: \(rawValue))"
        case .home: "\(description) home (Carbon.kVK_Home: \(rawValue))"
            
        case .f1: "\(description) f1 (Carbon.kVK_F1: \(rawValue))"
        case .f2: "\(description) f2 (Carbon.kVK_F2: \(rawValue))"
        case .f3: "\(description) f3 (Carbon.kVK_F3: \(rawValue))"
        case .f4: "\(description) f4 (Carbon.kVK_F4: \(rawValue))"
        case .f5: "\(description) f5 (Carbon.kVK_F5: \(rawValue))"
        case .f6: "\(description) f6 (Carbon.kVK_F6: \(rawValue))"
        case .f7: "\(description) f7 (Carbon.kVK_F7: \(rawValue))"
        case .f8: "\(description) f8 (Carbon.kVK_F8: \(rawValue))"
        case .f9: "\(description) f9 (Carbon.kVK_F9: \(rawValue))"
        case .f10: "\(description) f10 (Carbon.kVK_F10: \(rawValue))"
        case .f11: "\(description) f11 (Carbon.kVK_F11: \(rawValue))"
        case .f12: "\(description) f12 (Carbon.kVK_F12: \(rawValue))"
        case .f13: "\(description) f13 (Carbon.kVK_F13: \(rawValue))"
        case .f14: "\(description) f14 (Carbon.kVK_F14: \(rawValue))"
        case .f15: "\(description) f15 (Carbon.kVK_F15: \(rawValue))"
        case .f16: "\(description) f16 (Carbon.kVK_F16: \(rawValue))"
        case .f17: "\(description) f17 (Carbon.kVK_F17: \(rawValue))"
        case .f18: "\(description) f18 (Carbon.kVK_F18: \(rawValue))"
        case .f19: "\(description) f19 (Carbon.kVK_F19: \(rawValue))"
        case .f20: "\(description) f20 (Carbon.kVK_F20: \(rawValue))"
            
        case .apostrophe: "\(description) apostrophe (Carbon.kVK_ANSI_Quote: \(rawValue))"
        case .backApostrophe: "\(description) backApostrophe (Carbon.kVK_ANSI_Grave: \(rawValue))"
        case .backslash: "\(description) backslash (Carbon.kVK_ANSI_Backslash: \(rawValue))"
        case .capsLock: "\(description) capsLock (Carbon.kVK_CapsLock: \(rawValue))"
        case .comma: "\(description) comma (Carbon.kVK_ANSI_Comma: \(rawValue))"
        case .help: "\(description) help (Carbon.kVK_Help: \(rawValue))"
        case .forwardDelete: "\(description) forwardDelete (Carbon.kVK_ForwardDelete: \(rawValue))"
        case .decimal: "\(description) decimal (Carbon.kVK_ANSI_KeypadDecimal: \(rawValue))"
        case .delete: "\(description) delete (Carbon.kVK_Delete: \(rawValue))"
        case .equals: "\(description) equals (Carbon.kVK_ANSI_Equal: \(rawValue))"
        case .escape: "\(description) escape (Carbon.kVK_Escape: \(rawValue))"
        case .leftBracket: "\(description) leftBracket (Carbon.kVK_ANSI_LeftBracket: \(rawValue))"
        case .minus: "\(description) minus (Carbon.kVK_ANSI_Minus: \(rawValue))"
        case .multiply: "\(description) multiply (Carbon.kVK_ANSI_KeypadMultiply: \(rawValue))"
        case .period: "\(description) period (Carbon.kVK_ANSI_Period: \(rawValue))"
        case .return: "\(description) (Carbon: VK_Return (\(rawValue))"
        case .rightBracket: "\(description) rightBracket (Carbon.kVK_ANSI_RightBracket: \(rawValue))"
        case .semicolon: "\(description) semicolon (Carbon.kVK_ANSI_Semicolon: \(rawValue))"
        case .slash: "\(description) slash (Carbon.kVK_ANSI_Slash: \(rawValue))"
        case .space: "\(description) space (Carbon.kVK_Space: \(rawValue))"
        case .tab: "\(description) tab (Carbon.kVK_Tab: \(rawValue))"
        case .mute: "\(description) mute (Carbon.kVK_Mute: \(rawValue))"
        case .volumeDown: "\(description) volumeDown (Carbon.kVK_VolumeDown: \(rawValue))"
        case .volumeUp: "\(description) volumeUp (Carbon.kVK_VolumeUp: \(rawValue))"
            
        case .command: "\(description) command (Carbon.kVK_Command: \(rawValue))"
        case .rightCommand: "\(description) rightCommand (Carbon.kVK_RightCommand: \(rawValue))"
        case .control: "\(description) control (Carbon.kVK_Control: \(rawValue))"
        case .rightControl: "\(description) rightControl (Carbon.kVK_RightControl: \(rawValue))"
        case .function: "\(description) function (Carbon.kVK_Function: \(rawValue))"
        case .option: "\(description) option (Carbon.kVK_Option: \(rawValue))"
        case .rightOption: "\(description) rightOption (Carbon.kVK_RightOption: \(rawValue))"
        case .shift: "\(description) shift (Carbon.kVK_Shift: \(rawValue))"
        case .rightShift: "\(description) rightShift (Carbon.kVK_RightShift: \(rawValue))"
            
        case .downArrow: "\(description) downArrow (Carbon.kVK_DownArrow: \(rawValue))"
        case .leftArrow: "\(description) leftArrow (Carbon.kVK_LeftArrow: \(rawValue))"
        case .rightArrow: "\(description) rightArrow (Carbon.kVK_RightArrow: \(rawValue))"
        case .upArrow: "\(description) upArrow (Carbon.kVK_UpArrow: \(rawValue))"
        }
    }
}

extension Keyboard.Key: KeyboardKeyRepresentable {
    /// Taken from `SF Symbols.app`
    public var symbol: String {
        switch self {
        case .a: "􀂔" // "a"
        case .b: "􀂖"
        case .c: "􀂘"
        case .d: "􀂚"
        case .context: "􀂜"
        case .f: "􀂞"
        case .g: "􀂠"
        case .h: "􀂢"
        case .i: "􀂤"
        case .j: "\u{004A}" // Ｊ𝐉𝕁🄹
            
//            J
//            LATIN CAPITAL LETTER J
//        Unicode: U+004A, UTF-8: 4A
//
//            I
//            LATIN CAPITAL LETTER I
//        Unicode: U+0049, UTF-8: 49
            
        case .k: "k"
        case .l: "l"
        case .m: "m"
        case .n: "n"
        case .o: "o"
        case .p: "p"
        case .q: "q"
        case .r: "r"
        case .s: "s"
        case .t: "t"
        case .u: "u"
        case .v: "v"
        case .w: "w"
        case .x: "x"
        case .y: "y"
        case .z: "z"
            
        case .number0: "0"
        case .number1: "1"
        case .number2: "2"
        case .number3: "3"
        case .number4: "4"
        case .number5: "5"
        case .number6: "6"
        case .number7: "7"
        case .number8: "8"
        case .number9: "9"
            
        case .keypad0: "0 (keypad)"
        case .keypad1: "1 (keypad)"
        case .keypad2: "2 (keypad)"
        case .keypad3: "3 (keypad)"
        case .keypad4: "4 (keypad)"
        case .keypad5: "5 (keypad)"
        case .keypad6: "6 (keypad)"
        case .keypad7: "7 (keypad)"
        case .keypad8: "8 (keypad)"
        case .keypad9: "9 (keypad)"
        case .keypadClear: "clear (keypad)"
        case .keypadDivide: "divide (keypad)"
        case .keypadEnter: "enter (keypad)"
        case .keypadEquals: "􀆀"
        case .keypadMinus: "􀅽"
        case .keypadPlus: "􀅼"
            
        case .pageDown: "pageDown"
        case .pageUp: "pageUp"
        case .end: "end"
        case .home: "home"
            
        case .f1: "f1"
        case .f2: "f2"
        case .f3: "f3"
        case .f4: "f4"
        case .f5: "f5"
        case .f6: "f6"
        case .f7: "f7"
        case .f8: "f8"
        case .f9: "f9"
        case .f10: "f10"
        case .f11: "f11"
        case .f12: "f12"
        case .f13: "f13"
        case .f14: "f14"
        case .f15: "f15"
        case .f16: "f16"
        case .f17: "f17"
        case .f18: "f18"
        case .f19: "f19"
        case .f20: "f20"
            
        case .apostrophe: "'"
        case .backApostrophe: "`"
        case .backslash: #"\"#
        case .capsLock: "􀆡"
        case .comma: ","
        case .help: "help"
        case .forwardDelete: "􁂒"
        case .decimal: "decimal"
        case .delete: "􁂈"
        case .equals: "􀆀"
        case .escape: "􀆧"
        case .leftBracket: "["
        case .minus: "-"
        case .multiply: "*"
        case .period: "."
        case .return: "􀆎" // 􀅇
        case .rightBracket: "]"
        case .semicolon: ";"
        case .slash: "/"
        case .space: "􁁺"
        case .tab: "􀅂"
        case .mute: "􀊢"
        case .volumeDown: "􀊤"
        case .volumeUp: "􀊨"
            
        case .command: "􀆔"
        case .rightCommand: "􀆔"
        case .control: "􀆍"
        case .rightControl: "􀆍"
        case .function: "􀥌"
        case .option: "􀆕"
        case .rightOption: "􀆕"
        case .shift: "􀆝"
        case .rightShift: "􀆝"
            
        case .downArrow: "􀄩"
        case .leftArrow: "􀄪"
        case .rightArrow: "􀄫"
        case .upArrow: "􀄨"
        }
    }
    
    public var symbolName: String {
        switch self {
        case .a: "a.square"
        case .b: "b.square"
        case .c: "c.square"
        case .d: "d.square"
        case .context: "e.square"
        case .f: "f.square"
        case .g: "g.square"
        case .h: "h.square"
        case .i: "i.square"
        case .j: "j.square"
        case .k: "k.square"
        case .l: "l.square"
        case .m: "m.square"
        case .n: "n.square"
        case .o: "o.square"
        case .p: "p.square"
        case .q: "q.square"
        case .r: "r.square"
        case .s: "s.square"
        case .t: "t.square"
        case .u: "u.square"
        case .v: "v.square"
        case .w: "w.square"
        case .x: "x.square"
        case .y: "y.square"
        case .z: "z.square"
            
        case .number0: "0.square"
        case .number1: "1.square"
        case .number2: "2.square"
        case .number3: "3.square"
        case .number4: "4.square"
        case .number5: "5.square"
        case .number6: "6.square"
        case .number7: "7.square"
        case .number8: "8.square"
        case .number9: "9.square"
            
        case .keypad0: "0.square.fill"
        case .keypad1: "1.square.fill"
        case .keypad2: "2.square.fill"
        case .keypad3: "3.square.fill"
        case .keypad4: "4.square.fill"
        case .keypad5: "5.square.fill"
        case .keypad6: "6.square.fill"
        case .keypad7: "7.square.fill"
        case .keypad8: "8.square.fill"
        case .keypad9: "9.square.fill"
        case .keypadClear: "clear"
        case .keypadDivide: "divide"
        case .keypadEnter: "return" // ?
        case .keypadEquals: "equal"
        case .keypadMinus: "minus"
        case .keypadPlus: "plus"
            
        case .pageDown: ""
        case .pageUp: ""
        case .end: ""
        case .home: ""
            
        case .f1: ""
        case .f2: ""
        case .f3: ""
        case .f4: ""
        case .f5: ""
        case .f6: ""
        case .f7: ""
        case .f8: ""
        case .f9: ""
        case .f10: ""
        case .f11: ""
        case .f12: ""
        case .f13: ""
        case .f14: ""
        case .f15: ""
        case .f16: ""
        case .f17: ""
        case .f18: ""
        case .f19: ""
        case .f20: ""
            
        case .apostrophe: ""
        case .backApostrophe: ""
        case .backslash: ""
        case .capsLock: ""
        case .comma: ""
        case .help: ""
        case .forwardDelete: ""
        case .decimal: ""
        case .delete: ""
        case .equals: ""
        case .escape: ""
        case .leftBracket: ""
        case .minus: ""
        case .multiply: ""
        case .period: ""
        case .return: ""
        case .rightBracket: ""
        case .semicolon: ""
        case .slash: ""
        case .space: ""
        case .tab: ""
        case .mute: ""
        case .volumeDown: ""
        case .volumeUp: ""
            
        case .command: ""
        case .rightCommand: ""
        case .control: ""
        case .rightControl: ""
        case .function: ""
        case .option: ""
        case .rightOption: ""
        case .shift: ""
        case .rightShift: ""
            
        case .downArrow: ""
        case .leftArrow: ""
        case .rightArrow: ""
        case .upArrow: ""
        }
    }
}

extension NSEvent {
    // FIXME: @zakkhoyt - Maybe returning an optional value would be better than fatalError.
    
    /// Converts an `NSEvent` to `Keyboard.Key`
    /// - Remark: Will invoke `fatalError` if a conversion cannot take place.
    var keyboardKey: Keyboard.Key {
        guard let keyboardKey = Keyboard.Key(rawValue: keyCode) else {
            fatalError("Failed to convert NSEvent to Keyboard.Key: \(self)")
        }
        return keyboardKey
    }
}
#endif
