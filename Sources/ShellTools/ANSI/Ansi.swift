//
//  Ansi.swift
//
//
//  Created by Zakk Hoyt on 1/10/24.
//

import Foundation

/// Some ANSi codes have a value prefix. Some have a value postfix.
public enum ANSIParameterSequence {
    case constantBeforeValue
    case valueBeforeConstant
}

public protocol ANSIDescriber: Hashable {
    var summary: String { get }
    var commandLineArguments: [String] { get }
    
    var prefix: String { get }
    var printablePrefix: String { get }
    var constant: String { get }
    var valuesSeparator: String { get }
    var parameterSequence: ANSIParameterSequence { get }
    var suffix: String { get }
    
    var helpUsageDescription: String { get }
    var numberOfValues: Int { get }
    var isDemonstrableInHelp: Bool { get }
}

/// A enum/namespace to represent ANSI codes
///
/// # References
/// * [American National Standards Institute](https://en.wikipedia.org/wiki/ANSI_(disambiguation))
/// * [3-bit_and_4-bit color codes](https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit)
/// * [8-bit color codes](https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit)
/// * [24-bit (RGB) color codes](https://en.wikipedia.org/wiki/ANSI_escape_code#24-bit)
/// * [Article](https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html)
/// * [Video Terminal Programmer Info](https://vt100.net/docs/vt510-rm/DECSCUSR)
public enum ANSI: String, ANSIDescriber, CaseIterable {
    // MARK: Default State
    
    case `default`
    
    // MARK: Foreground Colors
    
    case defaultForeground
    
    // 3-bit 4-bit colors
    case blackForeground
    case redForeground
    case greenForeground
    case yellowForeground
    case blueForeground
    case magentaForeground
    case cyanForeground
    case whiteForeground
    
    // 3-bit 4-bit bright colors
    case brightBlackForeground
    case brightRedForeground
    case brightGreenForeground
    case brightYellowForeground
    case brightBlueForeground
    case brightMagentaForeground
    case brightCyanForeground
    case brightWhiteForeground
    
    // 8-bit colors
    case orangeForeground
    // TODO: zakkhoyt more...

    case eightBitForeground
    case rgbForeground
    
    // MARK: Background Colors
    
    case defaultBackground
    
    // Colors (3-bit 4-bit)
    case blackBackground
    case redBackground
    case greenBackground
    case yellowBackground
    case blueBackground
    case magentaBackground
    case cyanBackground
    case whiteBackground
    
    // Bright Colors (3-bit 4-bit)
    case brightBlackBackground
    case brightRedBackground
    case brightGreenBackground
    case brightYellowBackground
    case brightBlueBackground
    case brightMagentaBackground
    case brightCyanBackground
    case brightWhiteBackground
    
    // 8-bit colors
    case orangeBackground
    // TODO: zakkhoyt more...
    case eightBitBackground
    case rgbBackground
    
    // MARK: Fonts
    
    case boldFont
    case faintFont
    case italicFont
    case underlineFont
    case doubleUnderlineFont
    case blink
    case blinkFast
    case invertFont
    case hideFont
    case strikeout
    
    // MARK: Blinking
    
    // MARK: Erasing
    
    // TODO: zakkhoyt cursor movement
    // https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html
    
    // - Clear the screen, move to (0,0). EX: '\033[2J'
    // https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html
    case clearScreen
    
    // - Erase to end of line. EX: '\033[K'
    // https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html
    case eraseLine
    
    // MARK: Cursor
    
    case cursorUp
    case cursorDown
    case cursorRight
    case cursorLeft
    
    case cursorHide
    case cursorShow
    
    // component in helpUsage.
    public var summary: String {
        switch self {
        // MARK: Default State
            
        case .default: "Reset to defaults (foreground, background, font, etc...)"
            
        // MARK: Foreground Colors
            
        case .defaultForeground: "Default foreground color"
        case .blackForeground: "Black foreground color"
        case .redForeground: "Red foreground color"
        case .greenForeground: "Green foreground color"
        case .yellowForeground: "Yellow foreground color"
        case .blueForeground: "Blue foreground color"
        case .magentaForeground: "Magenta foreground color"
        case .cyanForeground: "Cyan foreground color"
        case .whiteForeground: "White foreground color"
        case .brightBlackForeground: "Bright black foreground color"
        case .brightRedForeground: "Bright red foreground color"
        case .brightGreenForeground: "Bright green foreground color"
        case .brightYellowForeground: "Bright yellow foreground color"
        case .brightBlueForeground: "Bright blue foreground color"
        case .brightMagentaForeground: "Bright magenta foreground color"
        case .brightCyanForeground: "Bright cyan foreground color"
        case .brightWhiteForeground: "Bright white foreground color"
        case .orangeForeground: "Orange foreground color."

        case .eightBitForeground: "8-bit RGB foreground color"
        case .rgbForeground: "RGB foreground color (24-bit)"
            
        // MARK: Background Colors
        
        case .defaultBackground: "Default background color"
        case .blackBackground: "Black background color"
        case .redBackground: "Red background color"
        case .greenBackground: "Green background color"
        case .yellowBackground: "Yellow background color"
        case .blueBackground: "Blue background color"
        case .magentaBackground: "Magenta background color"
        case .cyanBackground: "Cyan background color"
        case .whiteBackground: "White background color"
        case .brightBlackBackground: "Bright black background color"
        case .brightRedBackground: "Bright red background color"
        case .brightGreenBackground: "Bright green background color"
        case .brightYellowBackground: "Bright yellow background color"
        case .brightBlueBackground: "Bright blue background color"
        case .brightMagentaBackground: "Bright magenta background color"
        case .brightCyanBackground: "Bright cyan background color"
        case .brightWhiteBackground: "Bright white background color"
        case .orangeBackground: "Orange background color"

        case .eightBitBackground: "8-bit background color"
        case .rgbBackground: "RGB background color (24-bit)"
            
        // MARK: Fonts
            
        case .boldFont: "Bold font"
        case .faintFont: "Faint font"
        case .italicFont: "Italic font"
        case .underlineFont: "Underline"
        case .doubleUnderlineFont: "Double underline"
        case .blink: "Blink <= 150 Hz"
        case .blinkFast: "Blink > 150 Hz. Rarely supported"
        case .invertFont: "Invert font"
        case .hideFont: "Hide font"
        case .strikeout: "Strikeout"
            
        // MARK: Erasing
            
        case .clearScreen: "Clear screen"
        case .eraseLine: "Erase line"
            
        // MARK: Cursor
            
        case .cursorUp: "Move cursor up"
        case .cursorDown: "Move cursor down"
        case .cursorRight: "Move cursor right"
        case .cursorLeft: "Move cursor left"
            
        case .cursorHide: "Hide the cursor"
        case .cursorShow: "Show (unhide) the cursor"
        }
    }
    
    public var commandLineArguments: [String] {
        switch self {
        // MARK: Default State
            
        case .default: ["--default"]
            
        // MARK: Foreground Colors
            
        case .defaultForeground: ["-d", "--d", "--defaultForeground"]
        case .blackForeground: ["-black"]
        case .redForeground: ["-red"]
        case .greenForeground: ["-green"]
        case .yellowForeground: ["-yellow"]
        case .blueForeground: ["-blue"]
        case .magentaForeground: ["-magenta"]
        case .cyanForeground: ["-cyan"]
        case .whiteForeground: ["-white"]
        case .brightBlackForeground: ["--black"]
        case .brightRedForeground: ["--red"]
        case .brightGreenForeground: ["--green"]
        case .brightYellowForeground: ["--yellow"]
        case .brightBlueForeground: ["--blue"]
        case .brightMagentaForeground: ["--magenta"]
        case .brightCyanForeground: ["--cyan"]
        case .brightWhiteForeground: ["--white"]
            
        case .orangeForeground: ["--orange"]

        case .eightBitForeground: ["--8-bit"]
        case .rgbForeground: ["--rgb", "--24-bit"]
            
        // MARK: Background Colors
            
        case .defaultBackground: ["-D", "--D", "--defaultBackground"]
        case .blackBackground: ["-BLACK"]
        case .redBackground: ["-RED"]
        case .greenBackground: ["-GREEN"]
        case .yellowBackground: ["-YELLOW"]
        case .blueBackground: ["-BLUE"]
        case .magentaBackground: ["-MAGENTA"]
        case .cyanBackground: ["-CYAN"]
        case .whiteBackground: ["-WHITE"]
        case .brightBlackBackground: ["--BLACK"]
        case .brightRedBackground: ["--RED"]
        case .brightGreenBackground: ["--GREEN"]
        case .brightYellowBackground: ["--YELLOW"]
        case .brightBlueBackground: ["--BLUE"]
        case .brightMagentaBackground: ["--MAGENTA"]
        case .brightCyanBackground: ["--CYAN"]
        case .brightWhiteBackground: ["--WHITE"]
            
        case .orangeBackground: ["--ORANGE"]

        case .eightBitBackground: ["--8-BIT"]
        case .rgbBackground: ["--RGB", "--24-BIT"]
            
        // MARK: Fonts
            
        case .boldFont: ["--bold"]
        case .faintFont: ["--faint"]
        case .italicFont: ["--italic"]
        case .underlineFont: ["--underline"]
        case .doubleUnderlineFont: ["--double-underline"]
        case .invertFont: ["--invert", "--swap"]
        case .hideFont: ["--hide"]
        case .strikeout: ["--strikeout"]
            
        // MARK: Blinking
            
        case .blink: ["--blink"]
        case .blinkFast: ["--blinkFast"]
            
        // MARK: Erasing
            
        case .clearScreen: ["--clearScreen"]
        case .eraseLine: ["--eraseLine"]
            
        // MARK: Cursor
            
        case .cursorUp: ["--up"]
        case .cursorDown: ["--down"]
        case .cursorRight: ["--right"]
        case .cursorLeft: ["--left"]
            
        case .cursorHide: ["--cursor-hide"]
        case .cursorShow: ["--cursor-show"]
        }
    }
    
    public var helpUsageDescription: String {
        switch self {
        case .eightBitForeground,
             .eightBitBackground:
            // 0-7: standard colors
            // 8-15: bright colors
            // 16-231: yuv looking subsets
            // 232-255: grayscale
            let output = commandLineArguments.map {
                // "\($0) <0-255>"
                "\($0) <value>"
            }.joined(separator: ", ")
            // return "[" + output + "]"
            return output

        case .rgbForeground,
             .rgbBackground:
            let output = commandLineArguments.map {
                // "\($0) <R: 0-255> <G: 0-255> <B: 0-255>"
                "\($0) <r> <g> <b>"
            }.joined(separator: ", ")
            // return "[" + output + "]"
            return output

        case .cursorUp,
             .cursorDown,
             .cursorRight,
             .cursorLeft:
            let output = commandLineArguments.map {
                "\($0) <count>"
            }.joined(separator: ", ")
            // return "[" + output + "]"
            return output
            
        default:
            // return "[" + commandLineArguments.joined(separator: ", ") + "]"
            return commandLineArguments.joined(separator: ", ")
        }
    }
    
    public var numberOfValues: Int {
        // Some command line arguments require one or more values.
        // EX:
        // * "--cursorUp <N>"
        // * "--rgb <R> <G> <B>"
        switch self {
        case .eightBitForeground,
             .eightBitBackground,
             .cursorUp,
             .cursorDown,
             .cursorLeft,
             .cursorRight:
            1
        case .rgbForeground,
             .rgbBackground:
            3
        default:
            0
        }
    }
    
    public var isDemonstrableInHelp: Bool {
        switch self {
        case .eightBitForeground,
             .eightBitBackground,
             .rgbForeground,
             .rgbBackground,
             .clearScreen,
             .eraseLine,
             .cursorUp,
             .cursorDown,
             .cursorLeft,
             .cursorRight,
             .cursorHide,
             .cursorShow:
            false
        default:
            true
        }
    }
    
    public var prefix: String {
        Endcap.prefix
    }

    public var printablePrefix: String {
        Endcap.printablePrefix
    }
    
    public var constant: String {
        switch self {
        case .default: "0"
        
        // MARK: Foreground Colors
            
        case .defaultForeground: "39"
        
        // 3-bit 4-bit colors
        case .blackForeground: "30"
        case .redForeground: "31"
        case .greenForeground: "32"
        case .yellowForeground: "33"
        case .blueForeground: "34"
        case .magentaForeground: "35"
        case .cyanForeground: "36"
        case .whiteForeground: "37"
            
        // 3-bit 4-bit bright colors
        case .brightBlackForeground: "90"
        case .brightRedForeground: "91"
        case .brightGreenForeground: "92"
        case .brightYellowForeground: "93"
        case .brightBlueForeground: "94"
        case .brightMagentaForeground: "95"
        case .brightCyanForeground: "96"
        case .brightWhiteForeground: "97"
            
        // 8-bit colors
        case .orangeForeground: "38;5;208"

        // 0-7: standard colors
        // 8-15: bright colors
        // 16-231: yuv looking subsets
        // 232-255: grayscale
        case .eightBitForeground: "38;5;" // ESC[38;5;⟨i⟩

        case .rgbForeground: "38;2;" // ESC[38;2;⟨r⟩;⟨g⟩;⟨b⟩

        // MARK: Background Colors
            
        case .defaultBackground: "49"
            
        // Colors (3-bit 4-bit)
        case .blackBackground: "40"
        case .redBackground: "41"
        case .greenBackground: "42"
        case .yellowBackground: "43"
        case .blueBackground: "44"
        case .magentaBackground: "45"
        case .cyanBackground: "46"
        case .whiteBackground: "47"
            
        // Bright Colors (3-bit 4-bit)
        case .brightBlackBackground: "100"
        case .brightRedBackground: "101"
        case .brightGreenBackground: "102"
        case .brightYellowBackground: "103"
        case .brightBlueBackground: "104"
        case .brightMagentaBackground: "105"
        case .brightCyanBackground: "106"
        case .brightWhiteBackground: "107"
            
        // 8-bit colors
        case .orangeBackground: "48;5;208"
        case .eightBitBackground: "48;5;"
            
        case .rgbBackground: "48;2;"

        // MARK: Fonts
            
        case .boldFont: "1"
        case .faintFont: "2"
        case .italicFont: "3"
        case .underlineFont: "4"
        case .doubleUnderlineFont: "21"
        case .blink: "5"
        case .blinkFast: "6"
        case .invertFont: "7"
        case .hideFont: "8"
        case .strikeout: "9"
            
        // MARK: Erasing
        
        // TODO: zakkhoyt cursor movement
        // https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html
        
        // - Clear the screen, move to (0,0). EX: '\033[2J'
        // https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html
        case .clearScreen: "2J"
            
        // - Erase to end of line. EX: '\033[K'
        // https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html
        case .eraseLine: "K"
            
        // MARK: Cursor
            
        case .cursorUp: "A" // #"\033[\#(N)A"#
        case .cursorDown: "B" // #"\033[\#(N)B"#
        case .cursorRight: "C" // #"\033[\#(N)C"#
        case .cursorLeft: "D" // #"\033[\#(N)D"#
            
        case .cursorHide: "25l" // \033[25l
        case .cursorShow: "25h" // \033[25h
        }
    }
    
    public var valuesSeparator: String {
        Endcap.valueSeparator
    }

    public var parameterSequence: ANSIParameterSequence {
        switch self {
        case .cursorUp,
             .cursorDown,
             .cursorRight,
             .cursorLeft:
            .valueBeforeConstant
        default:
            .constantBeforeValue
        }
    }
    
    public var suffix: String {
        switch self {
        case .clearScreen,
             .eraseLine,
             .cursorUp,
             .cursorDown,
             .cursorLeft,
             .cursorRight,
             .cursorHide,
             .cursorShow:
            ""
        default:
            Endcap.suffix
        }
    }
    
    public enum Error: Swift.Error {
        /// `argument` does not begin with a `-`
        case notDashPrefixed(argument: String)

        /// `ANSI` could not be instantiated by `argument`.
        /// Likely a typo or user error.
        case noMatch(argument: String)
    }

    #warning("FIXME: zakkhoyt - decide on throwing or failable init")
    
    public init?(
        argument: String
    ) throws {
        guard argument.hasPrefix("-") else {
            return nil
//            throw Error.noMatch(argument: argument)
        }
        guard let ansi = (ANSI.allCases.first(where: {
            $0.commandLineArguments.contains { commandLineArgument in
                argument.hasPrefix(commandLineArgument)
            }
        })) else {
            return nil
//            throw Error.noMatch(argument: argument)
        }
        
        self = ansi
    }

#warning("""
TODO: zakkhoyt - DRY: Centralize escape codes (be the single source)
```log
2024-08-23 16:29:47.308 Db echo_pretty[86895:f2786e] [com.vaporwarewolf:echo_pretty] Showing ANSI Decorated Strings:
```
""")
//    2024-08-23 16:29:47.309 Db echo_pretty[86895:f2786e] [com.vaporwarewolf:echo_pretty]   \134^[[35mstdout.write("\134u{1B}[96m\134u{1B}[4mURL\134u{1B}[0m")\134^[[0m
//    2024-08-23 16:29:47.309 Db echo_pretty[86895:f2786e] [com.vaporwarewolf:echo_pretty]   \134^[[35mecho -e "\134x1B[96m\134x1B[4mURL\134x1B[0m"\134^[[0m
//    2024-08-23 16:29:47.309 Db echo_pretty[86895:f2786e] [com.vaporwarewolf:echo_pretty]   \134^[[35mprintf "\134x1B[96m\134x1B[4mURL\134x1B[0m"\134^[[0m

    
    public enum EscapeCode {
        case shell(isPrintable: Bool)
        case shellOctal(isPrintable: Bool)
        case swiftUnicode(isPrintable: Bool)
//        case textFile(isPrintable: Bool)

#warning("FIXME: zakkhoyt - Unprintable? Prints okay in VSCode: . Redirect any fastlane output to a file then open in VSCode")
        // 
        //            case .textFile(let isPrintable): isPrintable ? "" : ""

        
        #warning("FIXME: zakkhoyt - Fill in TODOs")
        var code: String {
            switch self {
            case .shell(let isPrintable): isPrintable ? "\\x1B" : "TODO"
            case .shellOctal(let isPrintable): isPrintable ? "\\033" : "TODO"
            case .swiftUnicode(let isPrintable): isPrintable ? "\u{1B}" : "\(String(Unicode.Scalar(UInt8(0x1B))))"

            // \134 = '\'
            // ^[ = ?
            // case .unifiedLogging(let isPrintable): isPrintable ? "\134^[" : "\(String(Unicode.Scalar(UInt8(0x1B))))"
            }
        }
    }

    /// The ANSI escape character. All ANSI codes begin with these characters.
    ///
    /// ## Shell Script
    /// * hex escape: `"\x1B["`
    /// * octal escape: `"\033["`
    /// ## Swift
    /// * unicode character: `0x001B`
    /// * escape: `"\u{1B}["`
    /// *
    public enum Endcap {
        //        static let defaultPrefix = "\u{1B}["
        public static let prefix = "\(String(Unicode.Scalar(UInt8(0x1B))))["
        public static let printablePrefix = "\\x1B["
        
        public static let valueSeparator = ";"
        
        // The suffix should only contain normal alphanumeric characters.
        public static let suffix = "m"
    }
}
