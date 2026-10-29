#!/usr/bin/env -S swift-sh
/// When using Swift in a scripting environment, it is not normally possible to import
/// 3rd party packages. We have a couple of options:
/// * `swift run <product_name> [cli_args]`
/// * `swift run echo_pretty --demo-basics`
/// * [swift-sh](https://github.com/mxcl/swift-sh)
/// comes in. Notice the shebang above and the comments on come of the `import` statements
/// below. Together these trigger `swift-sh` to download/build/cache a copy when run as a script.
/// Also this does not interfere if you choose to compile this swift code to binary.
/// Try `swift-sh --clean-cache` if you find yourself in a jam

/// This script is used in zshell/bash just like `echo` would be used. The difference is that this script
/// supports `ANSI` codes through command line arguments.
///
/// **Examples**
///
/// ```sh
/// echo_pretty "write to stderr" 1>&2
/// echo_pretty --red "red text," --default " and default text"
/// echo_pretty --red "Here is some red text. " --GREEN "Here is some green background." --default --debug
/// echo_pretty --help # See all options
/// ```
///
/// **Examples (different paths)**s
///
/// ```sh
/// # Call Script directly
/// Sources/EchoPretty/main.swift "write to stdout"
/// # Compiled output from VSCode
/// .build/debug/echo_pretty "write to stdout"
/// # Compiled output from Xcode
/// /Users/zakkhoyt/Library/Developer/Xcode/DerivedData/HatchTerminal-cjeenqfyvaitvxemximkxngrznzt/Build/Products/Debug/echo_pretty "write to stdout"
/// # After compiling, renaming, installing in PATH
/// echo_pretty "write to stdout"
/// ```


#warning(
    """
    TODO: zakkhoyt - Better support echo's arguments and escape characters
    * -n: Suppress newline suffix (last character)
    * -e: Process escaped characters. EX: \n
    * -E: Treat escaped characters as literals 
    * See: $HOME/Documents/notes/shell/ECHO.md
    * See: `man zshbuiltins`
    """
)


#warning("""
FIXME: zakkhoyt - update --demo
* By default? or can --demo take an arg?
* Replace echo line with output from
* --show-zsh
* --show-bash
* --show-swift
* write 8bit colors html
""")

#warning("""
FIXME: zakkhoyt (echo support) - Handle args & spaces more like echo. EX:
```sh
$ print 'one' 'two' 'three'
one two three
$ echo 'one' 'two' 'three'
one two three
$ echo_pretty 'one' 'two' 'three'
onetwothree
```
""")

#warning(
    """
    TODO: zakkhoyt (argParser, echo) - Bug when trying to print string that look like args. EX:
    ```sh
    $ echo "testing" '--dry-run' "end"
    testing --dry-run end
    $ echo_pretty "testing" '--dry-run' "end"
    testingend
    ```
    """
)

#warning("""
TODO: zakkhoyt (os.log support) - Support for logging like os.logger does?
* echo_pretty could either call hatch_log (if installed) or write directly to os.logger
* if direct, how to handle log level?
* ENV var support: ECHO_PRETTY_NO_TRAILING_DEFAULT_FLAG
""")

#warning("""
IDEA: zakkhoyt - Support common shell formatting like that seen in man, --help, etc...
* --man-header{n}
* --man-overview, --man-synopsis, --man-stdout, name, description, environment, exit-status, examples, references, SEE ALSO
""")

#warning("""
IDEA: zakkhoyt - Better hyperlink support
* While reading `man rg` I came cross "file://{host}{path} will emit an RFC 8089 hyperlink"
""")

import ANSIUtilities
import AppKit
import DrawingUI
import Foundation
import os

private let version = "2.6.0"

// swiftlint:disable:next prefixed_toplevel_constant
private let logger = os.Logger(
    subsystem: "co.hatch",
    category: "echo_pretty"
)

/// A seeded random number generator for deterministic testing
struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64
    
    init(seed: UInt64) {
        self.state = seed
    }
    
    mutating func next() -> UInt64 {
        // Linear congruential generator
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}

/// Prints to stderr and os.logger
func log(_ message: String) {
    FileDescriptor.stderr.writeLine(message)
    logger.debug("\(message, privacy: .public)")
}

/// Prints to stderr and os.logger if `isDebugMode` is set (pass `--debug` argument)
func debugPrint(_ message: String) {
#if DEBUG
    log(message)
    return
#else
    if CommandLine.arguments.contains("--debug") {
        log(message)
        return
    }
    
    if metaModes.contains(.debugMode) {
        log(message)
        return
    }
#endif
}

/// Prints (dumps) some debugging stuff to `stderr` including:
/// * `ProcessInfo.processInfo.environment`
/// * `ProcessInfo.processInfo.arguments`
/// * `CommandLine.arguments`
func printDump() {
    FileDescriptor.stderr.writeLine("-------- ProcessInfo.processInfo.environment: \(ProcessInfo.processInfo.environment.count)")
    let keys = ProcessInfo.processInfo.environment.keys.sorted()
    for (index, key) in keys.enumerated() {
        FileDescriptor.stderr.writeLine("\(index): \(key) = \(ProcessInfo.processInfo.environment[key] ?? "")")
    }
    FileDescriptor.stderr.writeLine("")
    
    FileDescriptor.stderr.writeLine("-------- ProcessInfo.processInfo.arguments: \(ProcessInfo.processInfo.arguments.count)")
    for (index, argument) in ProcessInfo.processInfo.arguments.enumerated() {
        FileDescriptor.stderr.writeLine("\(index): \(argument.description)")
    }
    FileDescriptor.stderr.writeLine("")
    
    FileDescriptor.stderr.writeLine("-------- CommandLine.arguments: \(CommandLine.arguments.count)")
    for (index, argument) in CommandLine.arguments.enumerated() {
        FileDescriptor.stderr.writeLine("\(index): \(argument.description)")
    }
    FileDescriptor.stderr.writeLine("")
}

func printUsage() {
#warning("""
FIXME: zakkhoyt - Use result builder to combine strings
* See HatchModuleMaker/FileBuilder
""")
    
    FileDescriptor.stderr.writeLines(
        [
            ANSI.UI.Help.overview(lines: ["Consider this to be an extension of echo with support for `ANSI` codes via command line arguments."]),
            ANSI.UI.Help.usage(lines: ["echo_pretty [echo flags] [options] text [options] [meta flags]"]),
            ANSI.UI.Help.optionsSection(
                title: "OPTIONS (echo)",
                summaryLines: [
                    """
                    Support for \(ANSI.UI.decorate(text: "echo", ansis: [.italicFont, .underlineFont])) arguments in \(ANSI.UI.decorate(text: "zsh", ansis: [.italicFont, .underlineFont])). \
                    To learn more: \(ANSI.UI.decorate(text: "man zshbuiltins", style: .code))
                    """
                ],
                tuples: (ArgumentFlag.echoFlags.map { ($0.rawValue, $0.helpDescription) })
            ),
            ANSI.UI.Help.optionsSection(
                title: "OPTIONS",
                summaryLines: ["Insert ANSI codes using the following."],
                tuples: ANSI.allCases.map {
                    if $0.isDemonstrableInHelp {
                        ($0.helpUsageDescription, "\($0.summary) \(ANSI.Item($0).code)EXAMPLE\(ANSI.Item(.default).code)")
                    } else {
                        ($0.helpUsageDescription, $0.summary)
                    }
                }
            ),
            ANSI.UI.Help.optionsSection(
                title: "OPTIONS (hyperlink)",
                summaryLines: [
                    """
                    Emit a clickable \(ANSI.UI.decorate(text: "OSC 8", style: .code)) terminal hyperlink. \
                    Unlike \(ANSI.UI.decorate(text: "--url", style: .code)) (which only styles text), this embeds a real link target. \
                    The value may be a Markdown link, an HTML anchor, or a bare URL, and may also be written as \(ANSI.UI.decorate(text: "--link=<string>", style: .code)). \
                    Unrecognized values are printed as plain text with a warning on stderr.
                    """
                ],
                tuples: [
                    (
                        "--link <string>",
                        #"Create a hyperlink from "[title](url)", "<a href=\"url\">title</a>", or "https://…"."#
                    )
                ]
            ),
            ANSI.UI.Help.optionsSection(
                title: "META OPTIONS",
                summaryLines: ["For help, demos, references, etc..."],
                tuples: (ArgumentFlag.metaFlags.map { ($0.rawValue, $0.helpDescription) })
            ),
            ANSI.UI.Help.section(
                title: "ENVIRONMENTAL VARIABLES",
                lines: [
                    "ECHO_PRETTY_NO_TRAILING_DEFAULT_FLAG       If set, the --default argument will be postfixed automatically"
                ]
            ),
            
            /// # References
            /// * [VT100.net: Digital VT220 Programmer Reference Manual Introduction](https://vt100.net/docs/vt220-rm/introduction.html)
            /// * [VT100.net: Digital VT220 Programmer Reference Manual Contents](https://vt100.net/docs/vt220-rm/contents.html)
            ///   * [Chapter 1, "Terminal Overview"](https://vt100.net/docs/vt220-rm/chapter1.html)
            ///   * [Chapter 2, "Character Encoding"](https://vt100.net/docs/vt220-rm/chapter2.html)
            ///   * [Chapter 3, "Transmitted Codes"](https://vt100.net/docs/vt220-rm/chapter3.html)
            ///   * [Chapter 4, "Received Codes"](https://vt100.net/docs/vt220-rm/chapter4.html)
            /// * [American National Standards Institute](https://en.wikipedia.org/wiki/ANSI_(disambiguation))
            /// * [Control Sequence Introducer commands](https://en.wikipedia.org/wiki/ANSI_escape_code#CSI_sequences)
            /// * [3-bit_and_4-bit color codes](https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit)
            /// * [8-bit color codes](https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit)
            /// * [24-bit (RGB) color codes](https://en.wikipedia.org/wiki/ANSI_escape_code#24-bit)
            /// * [Article](https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html)
            /// * [Video Terminal Programmer Info](https://vt100.net/docs/vt510-rm/DECSCUSR)
            ANSI.UI.Help.section(
                title: "REFERENCES",
                lines: [

                    // "[VT100.net: Digital VT220 Programmer Reference Manual Contents](https://vt100.net/docs/vt220-rm/contents.html)",
                    // "[VT100.net: Digital VT220 Programmer Reference Manual](https://vt100.net/docs/vt220-rm/chapter4.html)",

                    "* [VT100.net: Digital VT220 Programmer Reference Manual Contents](https://vt100.net/docs/vt220-rm/contents.html)",
                    "  * [VT100.net: Digital VT220 Programmer Reference Manual Introduction](https://vt100.net/docs/vt220-rm/introduction.html)",
                    "    * [Chapter 1, \"Terminal Overview\"](https://vt100.net/docs/vt220-rm/chapter1.html)",
                    "    * [Chapter 2, \"Character Encoding\"](https://vt100.net/docs/vt220-rm/chapter2.html)",
                    "    * [Chapter 3, \"Transmitted Codes\"](https://vt100.net/docs/vt220-rm/chapter3.html)",
                    "    * [Chapter 4, \"Received Codes\"](https://vt100.net/docs/vt220-rm/chapter4.html)",
                    "* American National Standards Institute: \(ANSI.UI.url(text: "https://en.wikipedia.org/wiki/ANSI_(disambiguation)"))",
                    "  * Control Sequence Introducer commands: \(ANSI.UI.url(text: "https://en.wikipedia.org/wiki/ANSI_escape_code#CSI_sequences"))",
                    "  * 3-bit_and_4-bit color codes: \(ANSI.UI.url(text: "https://en.wikipedia.org/wiki/ANSI_escape_code#3-bit_and_4-bit"))",
                    "  * 8-bit color codes: \(ANSI.UI.url(text: "https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit"))",
                    "  * 24-bit (RGB) color codes: \(ANSI.UI.url(text: "https://en.wikipedia.org/wiki/ANSI_escape_code#24-bit"))",                    
                    "* Article: \(ANSI.UI.url(text: "https://tldp.org/HOWTO/Bash-Prompt-HOWTO/x361.html"))",
                    "* Video Terminal Programmer Info: \(ANSI.UI.url(text: "https://vt100.net/docs/vt510-rm/DECSCUSR"))"
                ]
            )
        ]
    )
}

/// Used to print a section of literals at a time
func printSection(
    header: String,
    headerDestination: FileDescriptor = .stdout,
    lines: [LiteralTuple],
    linesDestination: FileDescriptor = .stdout
) {
    headerDestination.writeLine(header)
    //    let section = lines.reduce(into: header) { // partialResult, (name: String, value: String) in
    let section = lines.reduce(into: "") { // partialResult, (name: String, value: String) in
        let line = [
            $1.name,
            $1.value
        ]
            .joined(separator: "=")
        
        $0 = [$0, line].joined(separator: "\n")
    }
    linesDestination.write([section, ""].joined(separator: "\n"))
}

func demoCompare() {
    let indent = "  "
    
    FileDescriptor.stderr.writeLines(
        [
            ANSI.UI.Help.overview(
                lines: [
                    "\(ANSI.UI.decorate(text: "echo_pretty", style: .code)) can be considered to be an extension of \(ANSI.UI.decorate(text: "echo", style: .code)) that supports \(ANSI.UI.decorate(text: "ANSI", style: .code)) escape codes via command line arguments.",
                    "This demonstration compares usage of \(ANSI.UI.decorate(text: "echo", style: .code)) vs \(ANSI.UI.decorate(text: "echo_pretty", style: .code)) for several common formats.",
                    "",
                    "\(indent)All \(ANSI.UI.decorate(text: "echo", style: .code)) examples below are expressed in terms of \(ANSI.UI.decorate(text: "zshell", style: .code)).",
                    "\(indent)All \(ANSI.UI.decorate(text: "echo", style: .code)) examples below are expressed in terms of \(ANSI.UI.decorate(text: "zshell", style: .code)).",
                    "\(indent)If using \(ANSI.UI.decorate(text: "bash", style: .code)) it is necessary to use the \(ANSI.UI.decorate(text: "-e", style: .code)) argument (which is the default in \(ANSI.UI.decorate(text: "zshell", style: .code)))"
                ]
            ),
            ANSI.allCases
                .compactMap {
                    guard $0.isDemonstrableInHelp else { return nil }
                    let ansiItem = ANSI.Item($0)
                    let examplePrefix = "An "
                    let example = "EXAMPLE"
                    let exampleSuffix = " usage."
                    let ansiItemDefault = ANSI.Item(.default)
                    
                    let exampleZsh = "EXAMPLE_FOR_ZSH"
                    let echoSourceZsh = "\(#"echo "\#(examplePrefix)\#(ansiItem.printableCode)\#(exampleZsh)\#(ansiItemDefault.printableCode)\#(exampleSuffix)""#) 1>&2"
                    let escapedForZsh = echoSourceZsh.replacingOccurrences(of: "$", with: "\\$")
                    
                    //                    let exampleBash = "EXAMPLE_FOR_BASH"
                    //                    let echoSourceBash = "\(#"echo -e "\#(examplePrefix)\#(ansiItem.printableCode)\#(exampleBash)\#(ansiItemDefault.printableCode)\#(exampleSuffix)""#) 1>&2"
                    //                    let escapedForBash = echoSourceBash.replacingOccurrences(of: "$", with: "\\$")
                    
#warning(
                        """
                        TODO: zakkhoyt - Query terminal to see which shell is running, then include that example
                        Or.... allow the --demo arg express a value
                        """
                    )
                    //                    "\(#"echo "\#(examplePrefix)\#(ansiItem.printableCode)\#(example)\#(ansiItemDefault.printableCode)\#(exampleSuffix)""#)",
                    return ANSI.UI.Help.subsection(
                        title: $0.summary,
                        lines: [
                            "\(#"echo_pretty "\#(examplePrefix)" \#(ansiItem.helpUsageDescription) "\#(example)" \#(ansiItemDefault.helpUsageDescription) "\#(exampleSuffix)""#)",
                            "\(indent)\(#"\#(examplePrefix)\#(ansiItem.code)\#(example)\#(ansiItemDefault.code)\#(exampleSuffix)"#)",
                            escapedForZsh,
                            "\(indent)\(#"\#(examplePrefix)\#(ansiItem.code)\#(exampleZsh)\#(ansiItemDefault.code)\#(exampleSuffix)"#)"
                            //                            escapedForBash,
                            //                            "\(indent)\(#"\#(examplePrefix)\#(ansiItem.code)\#(exampleBash)\#(ansiItemDefault.code)\#(exampleSuffix)"#)",
                        ]
                    )
                }
                .joined(separator: "\n"),
            // `--link` is not an `ANSI` case (it takes a string value and emits a self-closing
            // OSC 8 sequence rather than a stateful CSI code), so it is demonstrated explicitly
            // here rather than via the `ANSI.allCases` loop above.
            ANSI.UI.Help.subsection(
                title: "Hyperlink (OSC 8)",
                lines: {
                    let uri = "https://example.com"
                    let linkTitle = "the docs"
                    let hyperlink = ANSI.Hyperlink(uri: uri, title: linkTitle, style: ANSI.Group.url.ansis)
                    let prefix = "See "
                    let suffix = " here."
                    let echoSourceZsh = #"echo "\#(prefix)\#(hyperlink.printableCode)\#(suffix)" 1>&2"#
                        .replacingOccurrences(of: "$", with: "\\$")
                    return [
                        #"echo_pretty "\#(prefix)" --link "[\#(linkTitle)](\#(uri))" "\#(suffix)""#,
                        "\(indent)\(prefix)\(hyperlink.code)\(suffix)",
                        echoSourceZsh,
                        "\(indent)\(prefix)\(hyperlink.code)\(suffix)"
                    ]
                }()
            )
            //            ANSI.Group.allCases
            //                .compactMap {
            //                    // Must filter out those that need multiple data values
            //                    if $0.ansis.contains(where: { $0 == .rgbForeground || $0 == .eightBitForeground }) {
            //                        return nil
            //                    }
            //                    let ansiItems = $0.ansis.map { ANSI.Item($0) }
            //                    let isDemonstrableInHelp = ansiItems.allSatisfy(\.isDemonstrableInHelp)
            //                    guard isDemonstrableInHelp else { return nil }
            //
            //
            //                    let examplePrefix = "An "
            //                    let example = "EXAMPLE"
            //                    let exampleSuffix = " usage."
            //                    let ansiItemDefault = ANSI.Item(.default)
            //
            //
            //                    let helpUsageDescription = ansiItems.map { $0.helpUsageDescription }.joined(separator: ", ")
            //                    let printableCodes = ansiItems.map { $0.printableCode }.joined()
            //                    let codes = ansiItems.map { $0.code }.joined()
            //
            //                    return ANSI.UI.Help.subsection(
            //                        title: $0.debugDescription,
            //                        lines: [
            //                            "\(#"echo "\#(examplePrefix)\#(printableCodes)\#(example)\#(ansiItemDefault.printableCode)\#(exampleSuffix)""#)",
            //                            "\(indent)\(#"\#(examplePrefix)\#(codes)\#(example)\#(ansiItemDefault.code)\#(exampleSuffix)"#)",
            //                            "\(#"echo_pretty "\#(examplePrefix)" \#(helpUsageDescription) "\#(example)" \#(helpUsageDescription) "\#(exampleSuffix)""#)",
            //                            "\(indent)\(#"\#(examplePrefix)\#(codes)\#(example)\#(ansiItemDefault.code)\#(exampleSuffix)"#)"
            //                        ]
            //                    )
            //                }
            //                .joined(separator: "\n")
        ]
    )
}

func demoWebColors() {
    let indent = "  "
    let examplePrefix = "Example "
    let exampleFG = "foreground"
    let exampleMiddle = " and "
    let exampleBG = "background"
    let exampleSuffix = " colors."
    let defaultItem = ANSI.Item(.default)
    
    FileDescriptor.stderr.writeLines(
        [
            ANSI.UI.Help.overview(
                lines: [
                    "Learn more about \(ANSI.UI.decorate(text: "web colors", style: .code)) here: \(ANSI.UI.decorate(text: "https://en.wikipedia.org/wiki/Web_colors#Extended_colors", style: .url))"
                ]
            ),
            
            WebColor.allCases.compactMap { webColor in
                let fgItem = ANSI.Item(
                    .rgbForeground,
                    values: webColor.rgb
                )
                let bgItem = ANSI.Item(
                    .rgbBackground,
                    values: webColor.rgb
                )
                //                let nameAndHexString = "\(webColor.name.padded(length: 64, endfix: .suffix)) (\(webColor.hexString))"
                let nameAndHexString = "\(ANSI.UI.decorate(text: webColor.name.padded(length: 96, endfix: .suffix), ansis: [.boldFont])) (\(ANSI.UI.decorate(text: webColor.hexString, ansis: [.italicFont, .underlineFont])))"
                let rgbArgs = webColor.rgb8Bit.map { "\($0.hexString)" }.joined(separator: " ")
                //                return [
                //                    "\(indent)\(nameAndHexString)",
                //                    // Example foreground and background colors.
                //                    "\(#"\#(indent)\#(indent)\#(examplePrefix) \#(fgItem.code)foreground\#(defaultItem.code) and \#(bgItem.code)background\#(defaultItem.code) colors."#)",
                //                    "\(#"\#(indent)\#(indent)echo_pretty "\#(examplePrefix)" \#(fgItem.commandLineArguments.first ?? "") \#(rgbArgs) "\#(exampleFG)" \#(defaultItem.helpUsageDescription) "\#(exampleMiddle)" \#(bgItem.commandLineArguments.first ?? "") \#(rgbArgs) "\#(exampleBG)" \#(defaultItem.helpUsageDescription)"\#(exampleSuffix)""#)"
                //                ].joined(separator: "\n")
                return [
                    "\(indent)\(nameAndHexString)",
                    // Example foreground and background colors.
                    "\(#"\#(indent)\#(indent)\#(examplePrefix)\#(fgItem.code)foreground\#(defaultItem.code)\#(exampleMiddle)\#(bgItem.code)background\#(defaultItem.code) colors."#)",
                    "\(#"\#(indent)\#(indent)echo_pretty "\#(examplePrefix)" \#(fgItem.commandLineArguments.first ?? "") \#(rgbArgs) "\#(exampleFG)" \#(defaultItem.helpUsageDescription) "\#(exampleMiddle)" \#(bgItem.commandLineArguments.first ?? "") \#(rgbArgs) "\#(exampleBG)" \#(defaultItem.helpUsageDescription)"\#(exampleSuffix)""#)"
                ].joined(separator: "\n")
                
                //                return ANSI.UI.Help.subsection(
                //                    title: nameAndHexString,
                //                    lines: [
                ////                        "\(indent)\(nameAndHexString)",
                ////                        // Example foreground and background colors.
                //                        "\(#"\#(indent)\#(indent)\#(examplePrefix) \#(fgItem.code)foreground\#(defaultItem.code) and \#(bgItem.code)background\#(defaultItem.code) colors."#)",
                //                        "\(#"\#(indent)\#(indent)echo_pretty "\#(examplePrefix)" \#(fgItem.commandLineArguments.first ?? "") \#(rgbArgs) "\#(exampleFG)" \#(defaultItem.helpUsageDescription) "\#(exampleMiddle)" \#(bgItem.commandLineArguments.first ?? "") \#(rgbArgs) "\#(exampleBG)" \#(defaultItem.helpUsageDescription)"\#(exampleSuffix)""#)"
                //                    ]
                //                )
                
            }.joined(separator: "\n")
        ]
    )
}

func demo8Bit() {
    // r=0; g=0; b=0; 16 + 36 × r + 6 × g + b
    // 16 + 36 × r + 6 × g + b
    // 16 + 36 × 0 + 6 × 0 + 0 => 16
    // 16 + 36 × 5 + 6 × 5 + 5 => 231
    
    var lines = [
        "8-bit color demo",
        "A look up table where input is 0...255 and output is a color (foreground or background).",
        """
            0-7:  Sstandard colors (as in black, red, green, yellow, blue, magenta, cyan, white)
           8-15:  High intensity colors (as in BLACK, RED, GREEN, YELLOW, BLUE, MAGENTA, CYAN, WHITE)
         16-231:  A 6 × 6 × 6 cube (216 colors): 16 + 36 × r + 6 × g + b (where 0...5 ~= [r, g, b])
        232-255:  Grayscale from dark to light in 24 steps (0...23
        """,
        "See details: \(ANSI.UI.decorate(text: "https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit", ansis: [.cyanForeground, .underlineFont]))",
        ""
    ]
    lines.append(
        contentsOf: (UInt8.min...UInt8.max).map {
            let fgItem = ANSI.Item(.eightBitForeground, values: [Int($0)])
            let foreground = ANSI.UI.decorate(text: "echo_pretty --8-bit \("\($0)".padded(length: 3, endfix: .suffix))", item: fgItem)
            //            let fgCode = fgItem.printableCode.padded(length: 14, endfix: .suffix)
#warning("FIXME: zakkhoyt - DRY: Centralize escape codes")
            //            /// -SeeAlso: [Sources/ANSIUtilities/Ansi.swift](Sources/ANSIUtilities/Ansi.swift)
            //            let fgCodeSwift = fgItem.printableCode.replacingOccurrences(of: "\\x1B", with: "\\u{1B}").padded(length: 15)
            
            let bgItem = ANSI.Item(.eightBitBackground, values: [Int($0)])
            let background = ANSI.UI.decorate(text: "echo_pretty --8-BIT \("\($0)".padded(length: 3, endfix: .suffix))", item: bgItem)
            //            let bgCode = bgItem.printableCode.padded(length: 14, endfix: .suffix)
            //            let bgCodeSwift = bgItem.printableCode.replacingOccurrences(of: "\\x1B", with: "\\u{1B}").padded(length: 15)
            return "  \(foreground) \(background)"
        }
    )
    FileDescriptor.stderr.writeLines(lines)
}

func demo24Bit() {
    var lines = [
        "24-bit color demo",
        "See details: \(ANSI.UI.decorate(text: "https://en.wikipedia.org/wiki/ANSI_escape_code#24-bit", ansis: [.cyanForeground, .underlineFont]))",
        ""
    ]
    
    let divisor: UInt8 = 32
    let from: UInt8 = divisor - 1
    let through = UInt8.max
    lines.append(
        contentsOf: [
            "Striding (r g b) from: \(from), through: \(through) by: \(divisor)",
            ""
        ]
    )
    
    /// Keeps UInt8 aligned to make nice hex numbers like 0x40, 0x60, 0x80,
    /// vs 0x5F, 0x7F, 0x9F.
    /// This is done by adding to `i` where needed.
    /// - Parameter i: The number to align
    /// - Returns: An aligned number
    func align(_ i: UInt8) -> UInt8 {
        i == 255 ? i : i + 1
    }
    for rr in stride(from: from, through: through, by: Int(divisor)) {
        let r = align(rr)
        for gg in stride(from: from, through: through, by: Int(divisor)) {
            let g = align(gg)
            for bb in stride(from: from, through: through, by: Int(divisor)) {
                let b = align(bb)
                let foreground = ANSI.UI.decorate(text: "echo_pretty --24-bit \(r) \(g) \(b)".padded(length: 32, endfix: .suffix), item: ANSI.Item(.rgbForeground, values: [Int(r), Int(g), Int(b)]))
                let background = ANSI.UI.decorate(text: "echo_pretty --24-BIT \(r) \(g) \(b)".padded(length: 32, endfix: .suffix), item: ANSI.Item(.rgbBackground, values: [Int(r), Int(g), Int(b)]))
                lines.append("  \(foreground) \(background)")
            }
        }
    }
    lines.append("")
    
    lines.append(
        contentsOf: [
            "Randomized (r g b). Also using hex values",
            ""
        ]
    )
    
    // Support deterministic random generation for testing
    // If ECHO_PRETTY_TEST_SEED environment variable is set, use a seeded generator
    var generator: any RandomNumberGenerator = SystemRandomNumberGenerator()
    if let seedString = ProcessInfo.processInfo.environment["ECHO_PRETTY_TEST_SEED"],
       let seed = UInt64(seedString) {
        generator = SeededRandomNumberGenerator(seed: seed)
    }
    
    for _ in 0..<16 {
        let r = UInt8.random(in: UInt8.min...UInt8.max, using: &generator)
        let g = UInt8.random(in: UInt8.min...UInt8.max, using: &generator)
        let b = UInt8.random(in: UInt8.min...UInt8.max, using: &generator)
        let foreground = ANSI.UI.decorate(text: "echo_pretty --24-bit \(r.hexString) \(g.hexString) \(b.hexString)".padded(length: 35, endfix: .suffix), item: ANSI.Item(.rgbForeground, values: [Int(r), Int(g), Int(b)]))
        let background = ANSI.UI.decorate(text: "echo_pretty --24-BIT \(r.hexString) \(g.hexString) \(b.hexString)".padded(length: 35, endfix: .suffix), item: ANSI.Item(.rgbBackground, values: [Int(r), Int(g), Int(b)]))
        lines.append("  \(foreground) \(background)")
    }
    lines.append("")
    
    FileDescriptor.stderr.writeLines(lines)
}

enum ArgumentFlag: String, CaseIterable {
    case helpFlag = "--help"
    
    case demoCompareFlag = "--demo"
    case demoBasicsFlag = "--demo-basics"
    case demo8BitFlag = "--demo-8-bit"
    case demo24BitFlag = "--demo-24-bit"
    case demoWebColorsFlag = "--demo-web-colors"
    case showANSIString = "--show"
    case showBash = "--show-bash"
    case showSwift = "--show-swift"
    case showZsh = "--show-zsh"
    
    case disableEscapeCharactersFlag = "-E"
    case disableTrailingNewlineFlag = "-n"
    
    case versionFlag = "--version"
    case dumpFlag = "--dump"
    case debugFlag = "--debug"
    
    var helpDescription: String {
        switch self {
        case .debugFlag:
            """
            Write debug info to stderr & os.logger.
                View stream: \u{1B}[93m\u{1B}[1mlog stream --predicate='category == echo_pretty --level=debug --style=compact\u{1B}[0m
            """
        case .disableEscapeCharactersFlag:
            "Disable escape character sequences. In other words treat them as string literals."
        case .disableTrailingNewlineFlag:
            "Do not print the trailing newline character. (echo argument)"
        case .demoCompareFlag:
            "A demonstration comparing echo_pretty syntax vs ANSI codes using echo"
        case .demoBasicsFlag:
            "Prints common ANSI escape code (litearls) for use in shell scripts"
        case .demo8BitFlag:
            "A demonstration of 8-bit color flags"
        case .demo24BitFlag:
            "A demonstration of 24-bit color flags"
        case .demoWebColorsFlag:
            "Prints escape codes for (litearls) for use in shell scripts"
        case .dumpFlag:
            "Write ProcessInfo arugments and environment to stderr"
        case .helpFlag:
            "Print the help/usage message (this message)"
            
        case .showZsh:
            "Encode ANSI string for zsh, write to stdout, and copy to pasteboard."
        case .showBash:
            "Encode ANSI string for bash, write to stdout, and copy to pasteboard."
        case .showSwift:
            "Encode ANSI string for swift, write to stdout, and copy to pasteboard."
        case .showANSIString:
            "Print pre-encoded ANSI strings. This is useful to generate/copy/paste decorated strings and debugging."
        case .versionFlag:
            "Prints the semantic version of the current build"
        }
    }
    
    var metaMode: MetaMode {
        switch self {
        case .debugFlag: .debugMode
        case .demoCompareFlag: .demoCompareMode
        case .demo8BitFlag: .demo8BitMode
        case .demo24BitFlag: .demo24BitMode
        case .demoBasicsFlag: .demoBasicsMode
        case .dumpFlag: .dumpMode
        case .disableEscapeCharactersFlag: .disableEscapeCharactersMode
        case .disableTrailingNewlineFlag: .disableTrailingNewlineMode
        case .helpFlag: .helpMode
        case .demoWebColorsFlag: .demoWebColorsMode
        case .showANSIString: .printAllFormatsMode
        case .showBash: .printAndCopyBashFormatMode
        case .showSwift: .printAndCopySwiftFormatMode
        case .showZsh: .printAndCopyZshFormatMode
        case .versionFlag: .versionMode
        }
    }
    
    static var metaFlags: [ArgumentFlag] {
        allCases.filter {
            !echoFlags.contains($0)
        }
    }
    
    static var echoFlags: [ArgumentFlag] {
        [
            .disableTrailingNewlineFlag,
            .disableEscapeCharactersFlag
        ]
    }
}

enum EnvironmentalVariable: String, CaseIterable {
    case enableTrailingDefault = "ECHO_PRETTY_ENABLE_TRAILING_DEFAULT"
    
    var metaMode: MetaMode {
        switch self {
        case .enableTrailingDefault: .enableTrailingDefaultMode
        }
    }
}

enum ProgrammingLanguage: String, CaseIterable {
    case shell
    case swift
}

#warning("FIXME: zakkhoyt easy: Merge MetaMode into ArgumentFlag")
/// A set of options to configure the app at launch.
///
/// `rawValue` is a bit mask of length 64 where only a single bit is set
/// ```swift
/// let rawValue: UInt64 = 1 << n
///
/// n = 0  // 0x000...(64 bits)...001
/// n = 1  // 0x000...(64 bits)...010
/// // n = (2..<64)
/// n = 62 // 0x010...(64 bits)...000
/// n = 63 // 0x100...(64 bits)...000
/// ```
struct MetaMode: OptionSet {
    var rawValue: UInt64
    
    static let helpMode = MetaMode(rawValue: 1 << 0) // 0x0000...(64 bits)...00
    static let versionMode = MetaMode(rawValue: 1 << 1) // 0x0000...(64 bits)...01
    
    static let demoBasicsMode = MetaMode(rawValue: 1 << 20)
    static let demoCompareMode = MetaMode(rawValue: 1 << 10)
    static let demo8BitMode = MetaMode(rawValue: 1 << 11)
    static let demo24BitMode = MetaMode(rawValue: 1 << 12)
    static let demoWebColorsMode = MetaMode(rawValue: 1 << 13)
    
    static let printAndCopyZshFormatMode = MetaMode(rawValue: 1 << 30)
    static let printAndCopyBashFormatMode = MetaMode(rawValue: 1 << 31)
    static let printAndCopySwiftFormatMode = MetaMode(rawValue: 1 << 32)
    static let printAllFormatsMode = MetaMode(rawValue: 1 << 39)
    
    static let disableEscapeCharactersMode = MetaMode(rawValue: 1 << 40)
    static let disableTrailingNewlineMode = MetaMode(rawValue: 1 << 41)
    static let enableTrailingDefaultMode = MetaMode(rawValue: 1 << 42)
    
    static let dumpMode = MetaMode(rawValue: 1 << 62) // 0x0100...(64 bits)...00
    static let debugMode = MetaMode(rawValue: 1 << 63) // 0x1000...(64 bits)...00
}

extension MetaMode: CustomStringConvertible {
    var description: String {
        switch self {
        case .debugMode: "debugMode"
        case .dumpMode: "dumpMode"
        case .helpMode: "helpMode"
        case .demo8BitMode: "demo8BitMode"
        case .demo24BitMode: "demo24BitMode"
        case .printAndCopyZshFormatMode: "printAndCopyZshFormatMode"
        case .printAndCopyBashFormatMode: "printAndCopyBashFormatMode"
        case .printAndCopySwiftFormatMode: "printAndCopySwiftFormatMode"
        case .printAllFormatsMode: "printAllFormatsMode"
        case .demoBasicsMode: "demoBasicsMode"
        case .versionMode: "versionMode"
        case .disableEscapeCharactersMode: "disableEscapeCharactersMode"
        case .disableTrailingNewlineMode: "disableTrailingNewlineMode"
        default: "combo (TODO: Compute description)"
        }
    }
}

enum DebugColor {
    case argument
    case ansiCode
    case text
    case output
    
    var item: ANSI.Item {
        switch self {
        case .argument: ANSI.Item(.whiteForeground)
        case .ansiCode: ANSI.Item(.orangeForeground)
        case .text: ANSI.Item(.yellowForeground)
        case .output: ANSI.Item(.brightCyanForeground)
        }
    }
}

/// This is an in-memory equivalent of the command line args/properties
struct Configuration: Codable {
    let date = Date.now
}

/// This function takes the original script arguments and categorizes them into two buckets.
/// * `metaModes: MetaFlags` - Arguments that don't affect what the script writes to stdout. EX: `--debug` or
/// `--help`.
/// * `ansiEchoArguments: [String]` - Flags and optoins which DO affect what the script writes
/// to stdout. EX: Strings, colors, fonts, cursor arguments, etc...
///
///
/// - Parameter arguments: The original arguments passed to this script. Caller should
/// pass `CommandLine.arguments` or `ProcessInfo.processInfo.arguments`.
/// - Returns: A tuple with three items. `metaModes` and `ansiEchoArguments` as detailed above
/// along with `diagnostics: [String]` (an array of debug messages).
func categorizeArguments(
    arguments allArgs: [String]
) -> (
    metaModes: MetaMode,
    ansiEchoArguments: [String],
    diagnostics: [String]
) {
#warning("FIXME: zakkhoyt - Either stick wtih colored debug on stderr or strip ANSI and use os.logger")
    var diagnostics = [String]()
    
    diagnostics.append("Will distill (\(allArgs.count)) arguments")
    for arg in allArgs.enumerated() {
        diagnostics.append("  allArgs[\(arg.offset)]: \(arg.element)")
    }
    
    //    diagnostics.append("  ")
    
    // Replace certain ags with a set of args
    let arguments: [String] = allArgs.flatMap {
        if $0 == "--code" {
            ["--yellow", "--bold"]
        } else if $0 == "--url" {
            ["--blue", "--underline"]
        } else if $0 == "--visited-url" {
            ["--24-bit", "128", "32", "255", "--underline"]
        } else {
            [$0]
        }
    }
    
    var metaModes = MetaMode() {
        didSet {
#warning("TODO: zakkhoyt - compute which metaModes are new and print them")
            diagnostics.append("      \("metaModes before: ".padded(length: metaModeColumnNumber, endfix: .suffix)) \(metaModes.rawValue.binaryString)")
            diagnostics.append("      \("metaModes after: ".padded(length: metaModeColumnNumber, endfix: .suffix)) \(metaModes.rawValue.binaryString)")
        }
    }
    var distilledArguments = arguments {
        didSet {
            diagnostics.append("      ansiEchoArguments.count before: \(distilledArguments.count)")
            diagnostics.append("      ansiEchoArguments.count after: \(distilledArguments.count)")
        }
    }
    
    // Strip of args[0] as it's the binary path
    diagnostics.append("  Inspecting args for binary path")
    if let first = arguments.first {
        diagnostics.append("    Arguments contains binary path. Did remove \(first)")
        distilledArguments.remove(at: 0)
    }
    
    // Iterate ArgumentFlag.allCases, looking for matches in allArgs
    let metaModeColumnNumber = 24
    
    diagnostics.append("Distilling [MetaMode] from [ArgumentFlag] via allArgs (\(allArgs.count))...")
    for item in ArgumentFlag.allCases.enumerated() {
        let argumentFlag = item.element
        let index = item.offset
        diagnostics.append("  Looking for \(argumentFlag.rawValue) (\(index) of \(ArgumentFlag.allCases.count))")
        if let matchIndex = distilledArguments.firstIndex(of: argumentFlag.rawValue) {
            let metaMode = argumentFlag.metaMode
            
            diagnostics.append("    \(argumentFlag.rawValue) was found at index \(matchIndex)")
            diagnostics.append("      ansiEchoArguments[\(matchIndex)]: \(distilledArguments[matchIndex]) == \(argumentFlag.rawValue)")
            diagnostics.append("    \("\(metaMode.description): ".padded(length: metaModeColumnNumber, endfix: .suffix)) \(metaMode.rawValue.binaryString)")
            metaModes.insert(argumentFlag.metaMode)
            
            diagnostics.append("    Arguments contains ArgumentFlag. Removed \(argumentFlag)")
            distilledArguments.remove(at: matchIndex)
        } else {
            diagnostics.append("    \(argumentFlag.rawValue) was not found")
        }
    }
    diagnostics.append("Distilling [MetaMode] from [EnvironmentalVariable] via ProcessInfo.processInfo.environment (\(ProcessInfo.processInfo.environment.count))...")
    for iter in EnvironmentalVariable.allCases.enumerated() {
        let envVarKey = iter.element
        let index = iter.offset
        diagnostics.append("  Looking for EnvironmentalVariable \(envVarKey.rawValue) (\(index) of \(EnvironmentalVariable.allCases.count))")
        if let envVarValue = ProcessInfo.processInfo.environment[envVarKey.rawValue], envVarValue.lowercased() != "false" {
            let metaMode = envVarKey.metaMode
            diagnostics.append("    \(envVarKey.rawValue) was found in ProcessInfo.processInfo.environment")
            diagnostics.append("    \("\(metaMode.description): ".padded(length: metaModeColumnNumber, endfix: .suffix)) \(metaMode.rawValue.binaryString)")
            metaModes.insert(envVarKey.metaMode)
        } else {
            diagnostics.append("    \(envVarKey.rawValue) was not found")
        }
    }
    
    diagnostics.append("Did distill \(CommandLine.arguments.count) arguments down to \(distilledArguments.count)")
    diagnostics.append("")
    
    /// Prrocesses the distilledArguments (modifies them if neededd)
    /// - Parameter distilledArguments: The non-meta arguments pased in from CLI.
    /// EX: Args like `--debug` are removed
    /// - Returns: Processed arguments.
    /// EX: Replace `"\\n"` with an actual newline `\n` instead of
    func processDistilledArguments(
        distilledArguments: [String]
    ) -> [String] {
        // Create a working copy that will be mutable for the score of this function
        var processedArguments: [String] = distilledArguments
        
        // MARK: Process Escape Characters
        
        if metaModes.contains(.disableEscapeCharactersMode) {
            // Nothing to do in this case. Pass escape chars on as literals
        } else {
            processedArguments = distilledArguments.enumerated().map { index, arg in
                // * [ ] `\a`     bell character
                // * [ ] `\b`     backspace
                // * [ ] `\c`     suppress subsequent characters and final newline
                // * [ ] `\e`     escape
                // * [ ] `\f`     form feed
                // * [X] `\n`     linefeed (newline)
                // * [ ] `\r`     carriage return
                // * [x] `\t`     horizontal tab
                // * [ ] `\v`     vertical tab
                // * [ ] `\\`     backslash
                // * [ ] `\0NNN`  character code in octal
                // * [ ] `\xNN`   character code in hexadecimal
                // * [ ] `\uNNNN` unicode character code in hexadecimal
                // * [ ] `\UNNNNNNNN` unicode character code in hexadecimal
                
                /// ```swift
                /// Sources/EchoPretty/main.swift "Testing \\n: abc\n123
                /// Testing \\t: abc\t123" --debug
                /// ```
                let processedArg = arg
                    .replacingOccurrences(of: "\\\\", with: "\\")
                    .replacingOccurrences(of: "\\n", with: "\n")
                    .replacingOccurrences(of: "\\t", with: "\t")
                
                debugPrint("processingEscapeChars")
                debugPrint("  distilledArguments[\(index)]")
                debugPrint("    input: arg")
                debugPrint("    output: processedArg")
                debugPrint("      changed: \(processedArg == arg)")
                return processedArg
            }
        }
        
        // MARK: Process Trailing --default
        
        let defaultFlagLiteral = ANSI.default.commandLineArguments[0]
        if metaModes.contains(.enableTrailingDefaultMode) {
            if processedArguments.last == defaultFlagLiteral {
                debugPrint("No need to apply .enableTrailingDefaultMode (last argument already set to \(defaultFlagLiteral))")
            } else {
                debugPrint("Applying .enableTrailingDefaultMode (appending \(defaultFlagLiteral)")
                processedArguments.append(defaultFlagLiteral)
            }
        } else {
            // Nothing to do. It up to the user to pass in `--default`
        }
        
        return processedArguments
    }
    
    debugPrint("distilledArguments -> processedArguments")
    let processedArguments: [String] = processDistilledArguments(
        distilledArguments: distilledArguments
    )
    
    return (metaModes, processedArguments, diagnostics)
}

let (metaModes, processedArguments, diagnostics) = categorizeArguments(
    arguments: CommandLine.arguments
)

// MARK: Execute demp modes if needed

if metaModes.contains(.dumpMode) {
    printDump()
}

if metaModes.contains(.debugMode) {
    debugPrint(diagnostics.joined(separator: "\n"))
}

if metaModes.contains(.versionMode) {
    FileDescriptor.stdout.writeLine(version)
    exit(0)
}

if metaModes.contains(.helpMode) {
    printUsage()
    exit(1)
}

if metaModes.contains(.demoBasicsMode) {
    demoBasics(language: .shell)
    exit(1)
}

if metaModes.contains(.demoCompareMode) {
    demoCompare()
    exit(1)
}

if metaModes.contains(.demo8BitMode) {
    demo8Bit()
    exit(1)
}

if metaModes.contains(.demo24BitMode) {
    demo24Bit()
    exit(1)
}

if metaModes.contains(.demoWebColorsMode) {
    demoWebColors()
    exit(1)
}

/// The result of attempting to interpret a `--link` value as an OSC 8 hyperlink.
enum HyperlinkParseResult {
    /// A title and URI were successfully extracted.
    case link(uri: String, title: String)
    /// The value is not a recognized link format.
    case unsupported
}

/// Parses a `--link` value into a hyperlink.
///
/// Recognized formats, in order:
/// * Markdown inline link: `[title](url)` or `[title](url "optional title")`
/// * HTML anchor: `<a href="url" ...>title</a>` (any attribute order, `'` or `"` quotes)
/// * Bare URL with a scheme: `https://…`, `file://…`, `mailto:…` (title defaults to the URL)
///
/// Optional attributes (a Markdown title, or extra HTML attributes like `target`/`class`)
/// are tolerated and discarded — they never cause a parse failure. OSC 8 has no tooltip
/// field, so there is nowhere to map them.
///
/// - Parameter string: The raw `--link` value.
/// - Returns: `.link` when a title + URI could be extracted, otherwise `.unsupported`.
func parseHyperlink(from string: String) -> HyperlinkParseResult {
    let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)

    // Markdown: [title](url) with an optional  "title"  attribute after the url.
    if let match = trimmed.wholeMatch(
        of: #/\[(?<title>[^\]]*)\]\(\s*(?<url>[^)\s]+)(?:\s+["'][^)]*)?\s*\)/#
    ) {
        return .link(uri: String(match.output.url), title: String(match.output.title))
    }

    // HTML anchor: <a ... href="url" ...>title</a>. Tolerates extra attributes and quote style.
    if let match = trimmed.wholeMatch(
        of: #/<a\b[^>]*\bhref\s*=\s*["'](?<url>[^"']*)["'][^>]*>(?<title>.*?)<\/a>/#.ignoresCase()
    ) {
        // Best-effort strip of any nested tags from the visible title.
        let title = String(match.output.title).replacing(#/<[^>]+>/#, with: "")
        return .link(uri: String(match.output.url), title: title)
    }

    // Bare URL: require a scheme (e.g. "https:", "file:", "mailto:") to be a usable target.
    if trimmed.firstMatch(of: #/^[a-zA-Z][a-zA-Z0-9+.\-]*:/#) != nil {
        return .link(uri: trimmed, title: trimmed)
    }

    return .unsupported
}

debugPrint("Will inspect \(processedArguments.count) processedArguments")
var outputs = [String]()
var printableOutputs = [String]()
var index = 0
while index < processedArguments.count {
    defer { index += 1 }
    let argument = processedArguments[index]

    // MARK: Handle --link (OSC 8 hyperlink)

    // `--link` takes a single *string* value (a Markdown link, HTML anchor, or bare URL).
    // It is handled before the ANSI check because the ANSI value pipeline below only
    // consumes integers. The emitted hyperlink is self-closing, so it cannot leak state
    // into following arguments.
    if argument == "--link" || argument.hasPrefix("--link=") {
        let linkString: String?
        if argument.hasPrefix("--link=") {
            linkString = String(argument.dropFirst("--link=".count))
        } else if index + 1 < processedArguments.count {
            linkString = processedArguments[index + 1]
            index += 1 // consume the value argument (the loop's `defer` advances past --link itself)
        } else {
            linkString = nil
        }

        guard let linkString else {
            FileDescriptor.stderr.writeLine(
                "[WARN] --link requires a value (a Markdown link, HTML anchor, or URL). Skipping. See --help."
            )
            continue
        }

        switch parseHyperlink(from: linkString) {
        case let .link(uri, title):
            // Style the visible title like --url (terminal hyperlinks carry no styling of
            // their own). Reuses ANSI.Group.url so it stays in sync with the --url flag.
            let hyperlink = ANSI.Hyperlink(uri: uri, title: title, style: ANSI.Group.url.ansis)
            debugPrint(#"    Converted --link to OSC 8 hyperlink: title='\#(title)' uri='\#(uri)'"#)
            outputs.append(hyperlink.code)
            printableOutputs.append(hyperlink.printableCode)
        case .unsupported:
            FileDescriptor.stderr.writeLine(
                #"[WARN] --link value '\#(linkString)' is not a recognized Markdown link, HTML anchor, or URL. Printing it as plain text."#
            )
            outputs.append(linkString)
            printableOutputs.append(linkString)
        }
        continue
    }

    // If we can convert the arg to ANSI, treat it as such. Otherwise treat as text to echo.
    guard let ansi = try? ANSI(argument: argument) else {
        debugPrint(#"    Converted to text: '\#(ANSI.UI.decorate(text: argument, item: DebugColor.text.item))'"#)
        outputs.append(argument)
        printableOutputs.append(argument)
        continue
    }
    
    defer { index += ansi.numberOfValues }
    
    debugPrint(#"  Inspecting arguments[\#(index)]: '\#(ANSI.UI.decorate(text: argument, item: DebugColor.argument.item))'"#)
    debugPrint(#"    Argument '\#(ANSI.UI.decorate(text: "\(argument)", item: DebugColor.argument.item))' requires \#(ansi.numberOfValues) value(s). Peeking..."#)
    
    let values: [Int] = (0..<ansi.numberOfValues).map {
        let offset = $0 + 1
        // Prevent out of bounds errors
        guard index + offset < processedArguments.count else {
            FileDescriptor.stderr.writeLine(#"""
            [ERROR] Argument '\#(ANSI.UI.decorate(text: "\(argument)", item: DebugColor.argument.item))' \
            requires \#(ansi.numberOfValues) value(s) which is greater than the number of arguments remaining. \
            See --help.
            """#)
            exit(2)
        }
        
        let nextArgument = processedArguments[index + offset]
        if let value = Int(nextArgument) {
            return value
        } else if let value = Int(hexString: nextArgument) {
            return value
        } else if let value = Int(binaryString: nextArgument) {
            return value
        } else {
            FileDescriptor.stderr.writeLine(#"[ERROR] Argument '\#(ANSI.UI.decorate(text: "\(argument)", item: DebugColor.argument.item))' arguments[\#(index + offset)] (\#(nextArgument)) does not represent an integer value. See --help."#)
            exit(3)
        }
    }
    
    let item = ANSI.Item(ansi, values: values)
    debugPrint(#"    Refined: arguments[\#(index)...\#(index + ansi.numberOfValues)]: '\#(ANSI.UI.decorate(text: "\(argument) \(values)", item: DebugColor.argument.item))'"#)
    debugPrint(#"    Converted to ANSI code"#)
    debugPrint(#"      Summary: \#(ANSI.UI.decorate(text: item.summary, item: DebugColor.ansiCode.item))"#)
    debugPrint(#"      Code: \#(ANSI.UI.decorate(text: item.printableCode, item: DebugColor.ansiCode.item))"#)
    
    outputs.append([item.code].joined())
    printableOutputs.append([item.printableCode].joined())
    
    debugPrint(#"    Appended to outputs: '\#(ANSI.UI.decorate(text: printableOutputs.joined(), item: DebugColor.output.item))'"#)
    debugPrint("")
}

debugPrint("Did inspect \(processedArguments.count) arguments")

debugPrint("")
debugPrint(#"Final outputs: \#(printableOutputs.joined())\#(ANSI.Item(.default).code)"#)

#warning("FIXME: zakkhoyt - DRY: Centralize escape codes")
/// -SeeAlso: [Sources/ANSIUtilities/Ansi.swift](Sources/ANSIUtilities/Ansi.swift)
debugPrint("")
debugPrint("ANSI Escape Code Syntax for 0x001B:")
debugPrint(#"  Shell: \x1B    (hex)"#)
debugPrint(#"  Shell: \033    (oct)"#)
debugPrint(#"  Swift: \u{1B}  (hex)"#)
// debugPrint(#"  VSCode:  (hex)"#)

func writeToClipboard(text: String) {
    NSPasteboard.general.declareTypes([.string], owner: nil)
    logger.debug("Will write to pasteboard: \(text, privacy: .public)")
    let success = NSPasteboard.general.setString(text, forType: .string)
    if success {
        logger.debug("Did write to pasteboard: \(text, privacy: .public)")
    } else {
        logger.error("Failed to write to pasteboard")
    }
}

#warning("FIXME: zakkhoyt - DRY: Centralize escape codes")
/// -SeeAlso: [Sources/ANSIUtilities/Ansi.swift](Sources/ANSIUtilities/Ansi.swift)

if metaModes.contains(.printAndCopySwiftFormatMode) || metaModes.contains(.printAllFormatsMode) {
    log("Formatted for Swift (copied to pasteboard)")
    // Unless we escape \, bash will render those to varible values. We want to print bash source code
    let escapedforSwift = printableOutputs.joined()
        .replacingOccurrences(of: "\\x1B", with: "\\u{1B}")
    let swiftSourceCode = #"stdout.write("\#(escapedforSwift)")"#
    log(#"  \#(ANSI.Item(.magentaForeground).code)\#(swiftSourceCode)\#(ANSI.Item(.default).code)"#)
    writeToClipboard(text: swiftSourceCode)
}

if metaModes.contains(.printAndCopyBashFormatMode) || metaModes.contains(.printAllFormatsMode) {
    log("Formatted for Bash (copied to pasteboard)")
    // Unless we escape $, bash will render those to varible values. We want to print bash source code
    let escapedForBash = printableOutputs.joined()
        .replacingOccurrences(of: "$", with: "\\$")
    let bashSourceCode = #"echo -e "\#(escapedForBash)" 1>&2"#
    log(#"  \#(ANSI.Item(.magentaForeground).code)\#(bashSourceCode)\#(ANSI.Item(.default).code)"#)
    writeToClipboard(text: bashSourceCode)
}

if metaModes.contains(.printAndCopyZshFormatMode) || metaModes.contains(.printAllFormatsMode) {
    log(" (copied to pasteboard)")
    // Unless we escape $, bash will render those to varible values. We want to print bash source code
    let escapedForZsh = printableOutputs.joined()
        .replacingOccurrences(of: "$", with: "\\$")
    let zshSourceCode = #"echo "\#(escapedForZsh)" 1>&2"#
    log(#"  \#(ANSI.Item(.magentaForeground).code)\#(zshSourceCode)\#(ANSI.Item(.default).code)"#)
    writeToClipboard(text: zshSourceCode)
}

// FileDescriptor.stdout.write(outputs.joined())

if metaModes.contains(.disableTrailingNewlineMode) {
    FileDescriptor.stdout.write(outputs.joined())
} else {
    FileDescriptor.stdout.writeLine(outputs.joined())
}

typealias LiteralTuple = (name: String, value: String)
func demoBasics(language: ProgrammingLanguage) {
    let literalComment = "#"
    let literalQuote = #"'"#
    let literalPrefix = "ANSI"
    let literalSeparator = "_"
    enum Literals {
        static let Comment = "#"
        static let Quote = #"'"#
        static let Prefix = "ANSI"
        static let Separator = "_"
    }
    
    let elementalLines: [LiteralTuple] = ANSI.allCases.filter {
        $0.isDemonstrableInHelp
    }
        .compactMap { ansi in
            guard let shellLiteralRoot: String = {
                switch ansi {
                    // MARK: Default State
                    
                case .default: "DEFAULT"
                    
                    // MARK: Foreground Colors
                    
                case .defaultForeground: "DEFAULT"
                case .blackForeground: "BLACK"
                case .redForeground: "RED"
                case .greenForeground: "GREEN"
                case .yellowForeground: "YELLOW"
                case .blueForeground: "BLUE"
                case .magentaForeground: "MAGENTA"
                case .cyanForeground: "CYAN"
                case .whiteForeground: "WHITE"
                case .orangeForeground: "ORANGE"
                case .brightBlackForeground: "BRIGHT_BLACK"
                case .brightRedForeground: "BRIGHT_RED"
                case .brightGreenForeground: "BRIGHT_GREEN"
                case .brightYellowForeground: "BRIGHT_YELLOW"
                case .brightBlueForeground: "BRIGHT_BLUE"
                case .brightMagentaForeground: "BRIGHT_MAGENTA"
                case .brightCyanForeground: "BRIGHT_CYAN"
                case .brightWhiteForeground: "BRIGHT_WHITE"
                    
                case .eightBitForeground: nil // "8-bit RGB foreground color"
                case .rgbForeground: nil // "RGB foreground color (24-bit)"
                    
                    // MARK: Background Colors
                    
                case .defaultBackground: "DEFAULT_BG"
                case .blackBackground: "BLACK_BG"
                case .redBackground: "RED_BG"
                case .greenBackground: "GREEN_BG"
                case .yellowBackground: "YELLOW_BG"
                case .blueBackground: "BLUE_BG"
                case .magentaBackground: "MAGENTA_BG"
                case .cyanBackground: "CYAN_BG"
                case .whiteBackground: "WHITE_BG"
                case .orangeBackground: "ORANGE_BG"
                case .brightBlackBackground: "BRIGHT_BLACK_BG"
                case .brightRedBackground: "BRIGHT_RED_BG"
                case .brightGreenBackground: "BRIGHT_GREEN_BG"
                case .brightYellowBackground: "BRIGHT_YELLOW_BG"
                case .brightBlueBackground: "BRIGHT_BLUE_BG"
                case .brightMagentaBackground: "BRIGHT_MAGENTA_BG"
                case .brightCyanBackground: "BRIGHT_CYAN_BG"
                case .brightWhiteBackground: "BRIGHT_WHITE_BG"
                    
                case .eightBitBackground: nil // "8-bit background color"
                case .rgbBackground: nil // "RGB background color (24-bit)"
                    
                    // MARK: Fonts
                    
                case .boldFont: "FONT_BOLD"
                case .faintFont: "FONT_FAINT"
                case .italicFont: "FONT_ITALIC"
                case .underlineFont: "FONT_UNDERLINE"
                case .doubleUnderlineFont: "FONT_DOUBLE_UNDERLINE"
                case .blink: "FONT_BLINK" //  <= 150 HZ
                case .blinkFast: "FONT_BLINK_FAST" //  > 150 HZ. RARELY SUPPORTED
                case .invertFont: "FONT_INVERT"
                case .hideFont: "FONT_HIDE"
                case .strikeout: "FONT_STRIKEOUT"
                    
                    // MARK: Erasing
                    
                case .clearScreen: "CLEAR_SCREEN"
                case .eraseLine: "ERASE_LINE"
                    
                    // MARK: Cursor
                    
                case .cursorUp: "CURSOR_MOVE_UP"
                case .cursorDown: "CURSOR_MOVE_DOWN"
                case .cursorRight: "CURSOR_MOVE_RIGHT"
                case .cursorLeft: "CURSOR_MOVE_LEFT"
                    
                case .cursorHide: "CURSOR_HIDE"
                case .cursorShow: "CURSOR_SHOW"
                }
            }() else { return nil }
            
            let shellLiteralName = [literalPrefix, shellLiteralRoot].joined(separator: literalSeparator)
            let shellColoredLiteralName = ANSI.UI.decorate(text: "\("\(shellLiteralName)".padded(length: 3, endfix: .suffix))", item: ANSI.Item(ansi))
            let shellLiteralValue = [literalQuote, ANSI.Item(ansi).printableCode, literalQuote].joined()
            let shellDemo = ANSI.UI.decorate(text: "\("\(shellLiteralName)".padded(length: 3, endfix: .suffix))", item: ANSI.Item(ansi))
            print("shellDemo: \(shellDemo)")
            return (shellColoredLiteralName, shellLiteralValue)
        }
    printSection(
        header: "\(literalComment) Shell literals for atomic ANSI codes",
        lines: elementalLines
    )
    
    let groupTuples: [LiteralTuple] = ANSI.Group
        .allCases
        .filter {
            $0.ansis.allSatisfy { $0.isDemonstrableInHelp }
        }
        .compactMap { ansiGroup in
            guard let shellLiteralRoot = {
                switch ansiGroup {
                case .url: "URL"
                case .visitedURL: "URL_VISITED"
                case .boldItalic: "FONT_BOLD_ITALIC"
                case .code: "CODE"
                case .error: "ERROR"
                }
            }() else { return nil }
            
            let shellLiteralName = [literalPrefix, shellLiteralRoot].joined(separator: literalSeparator)
            let shellColoredLiteralName = ANSI.UI.decorate(text: "\(shellLiteralName)", ansis: ansiGroup.ansis)
            let shellLiteralValue = [
                literalQuote,
                ansiGroup.ansis.reduce(into: "") { // partialResult, ANSI in
                    let item = ANSI.Item($1)
                    $0 = [$0, item.printableCode].joined()
                },
                literalQuote
            ].joined()
            
            //            return (shellLiteralName, shellLiteralValue)
            return (shellColoredLiteralName, shellLiteralValue)
        }
    
    printSection(
        header: "\(literalComment) Shell literals for ANSI.Group codes",
        lines: groupTuples
    )
    
    //    FileDescriptor.stderr.writeLine(#"\#(literalComment) ---- ---- ---- ---- Example usage ---- ---- ---- ---- "#)
    //    FileDescriptor.stderr.writeLine(#"\#(literalComment) First, Copy/paste the literals above into your \#(language.rawValue) script."#)
    //    FileDescriptor.stderr.writeLine(#"\#(literalComment)"#)
    //    FileDescriptor.stderr.writeLine(#"\#(literalComment) \#(literalComment) Example usage in zsh:"#)
    //    FileDescriptor.stderr.writeLine(#"\#(literalComment) echo "${ANSI_URL}http://some.url${ANSI_DEFAULT}""#)
    //    FileDescriptor.stderr.writeLine(#"\#(literalComment) printf "${ANSI_URL}http://some.url${ANSI_DEFAULT}\ndefault text""#)
    //    FileDescriptor.stderr.writeLine(#"\#(literalComment)"#)
    //    FileDescriptor.stderr.writeLine(#"\#(literalComment) \#(literalComment) Example compound usage in zsh:"#)
    //    FileDescriptor.stderr.writeLine(#"\#(literalComment) echo "${ANSI_BRIGHT_RED_FG}${ANSI_FONT_BLINK}[ERROR]${ANSI_DEFAULT}: Exiting with code 7!""#)
    //    FileDescriptor.stderr.writeLine(#"\#(literalComment)"#)
    //    FileDescriptor.stderr.writeLine(#"\#(literalComment) Example usage in bash:"#)
    //    FileDescriptor.stderr.writeLine(#"\#(literalComment) echo -e \#(literalComment) use the -e argument"#)
    //    FileDescriptor.stderr.writeLine(#"\#(literalComment)"#)
    
    FileDescriptor.stderr.writeLine(
        #"""
        \#(literalComment) ---- ---- ---- ---- Example usage ---- ---- ---- ----
        \#(literalComment) First, Copy/paste the literals above into your \#(language.rawValue) script.
        \#(literalComment)
        \#(literalComment) \#(literalComment) Example usage in zsh:
        \#(literalComment) echo "${ANSI_URL}http://some.url${ANSI_DEFAULT}"
        \#(literalComment) printf "${ANSI_URL}http://some.url${ANSI_DEFAULT}\ndefault text"
        \#(literalComment)
        \#(literalComment) \#(literalComment) Example compound usage in zsh:
        \#(literalComment) echo "${ANSI_BRIGHT_RED_FG}${ANSI_FONT_BLINK}[ERROR]${ANSI_DEFAULT}: Exiting with code 7!"
        \#(literalComment)
        \#(literalComment) Example usage in bash:
        \#(literalComment) echo -e \#(literalComment) use the -e argument
        \#(literalComment)
        """#
    )
}
