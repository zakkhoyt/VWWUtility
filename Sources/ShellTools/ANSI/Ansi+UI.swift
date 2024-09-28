//
//  Ansi+UI.swift
//
//
//  Created by Zakk Hoyt on 1/10/24.
//

// See: https://www.polpiella.dev/how-to-make-an-interactive-picker-for-a-swift-command-line-tool

import Foundation

extension ANSI {
    /// Functions to make it building ANSI Strings easier.
    ///
    public enum UI {
        public static let tab = "  "
                
        // MARK: Building block functions w/ANSI
        
        /// Decorates a `String` with ``ANSI`` codes.
        /// - Parameters:
        ///   - text: The `String` to decorate
        ///   - ansi: A single ``ANSI`` code to prefix to `text`
        ///   - endWithDefault: If `true`, end the string with `ANSI.default`.
        /// - Returns: A `String` containing `ANSI` codes for rending on command line.
        public static func decorate(
            text: String,
            ansi: ANSI,
            endWithDefault: Bool = true
        ) -> String {
            decorate(text: text, ansis: [ansi], endWithDefault: endWithDefault)
        }
        
        /// Decorates a `String` with ``ANSI`` codes.
        /// - Parameters:
        ///   - text: The `String` to decorate
        ///   - ansis: An array of ``ANSI`` codes to prefix to `text`
        ///   - endWithDefault: If `true`, end the string with `ANSI.default`.
        /// - Returns: A `String` containing `ANSI` codes for rending on command line.
        public static func decorate(
            text: String,
            ansis: [ANSI],
            endWithDefault: Bool = true
        ) -> String {
            decorate(text: text, items: ansis.map { ANSI.Item($0) }, endWithDefault: endWithDefault)
        }
        
        // MARK: Building block functions w/ANSI.Item
        
        /// Decorates a `String` by prefixing  an `ANSI.Item`.
        /// - Parameters:
        ///   - text: The `String` to decorate
        ///   - item: The `ANSI.Item` to prefix to `text`.
        ///   - endWithDefault: If `true`, end the string with `ANSI.default`.
        /// - Returns: A `String` containing `ANSI` codes for rending on command line.
        public static func decorate(
            text: String,
            item: ANSI.Item,
            endWithDefault: Bool = true
        ) -> String {
            decorate(text: text, items: [item], endWithDefault: endWithDefault)
        }
        
        /// Decorates a `String` by prefixing an array of ``ANSI`` codes.
        /// - Parameters:
        ///   - text: The `String` to decorate
        ///   - items: Array of ``ANSI.Item`` codes to prefix to `text`
        ///   - endWithDefault: If `true`, end the string with `ANSI.default`.
        /// - Returns: A `String` containing `ANSI` codes for rending on command line.
        /// - SeeAlso: ``ANSIDescriber``
        public static func decorate(
            text: String,
            items: [ANSI.Item],
            endWithDefault: Bool = true
        ) -> String {
            decorate(text: text, ansiStrings: items.map { $0.code }, endWithDefault: endWithDefault)
        }
        
        /// Decorates a `String` with ``ANSI`` codes expressed as a ``ANSI.Style``
        /// (`[ANSI]`).
        ///
        /// - Parameters:
        ///   - text: The `String` to decorate
        ///   - style: A predefined array of ``ANSI`` codes to prefix to `text`
        /// - Returns: A `String` containing `ANSI` codes for rending on command line.
        public static func decorate(
            text: String,
            style: ANSI.Style,
            endWithDefault: Bool = true
        ) -> String {
            decorate(text: text, ansis: style, endWithDefault: endWithDefault)
        }
        
        // MARK: - Private functions
        
        private static func decorate(
            text: String,
            ansiStrings: [String],
            endWithDefault: Bool = true
        ) -> String {
            guard !ansiStrings.isEmpty else { return text }
            return "\(ansiStrings.map { $0 }.joined())\(text)\(endWithDefault ? ANSI.Item(.default).code : "")"
        }
        
        // MARK: - Canned styles (Deprecated)
        
        /// Decorates `text` in **bold** style.
        /// - Parameter text: The text to decorate
        /// - Returns: A `String` containing `ANSI` codes for rending on command line.
        @available(*, renamed: "decorate(text:style:endWithDefault:)", message: "Use ANSI.Style to express combinations of ANSI codes")
        public static func bold(
            text: String,
            endWithDefault: Bool = true
        ) -> String {
            decorate(text: text, ansis: [.boldFont], endWithDefault: endWithDefault)
        }
        
        /// Decorates `text` in *italic* style.
        /// - Parameter text: The text to decorate
        /// - Returns: A `String` containing `ANSI` codes for rending on command line.
        @available(*, renamed: "decorate(text:style:endWithDefault:)", message: "Use ANSI.Style to express combinations of ANSI codes")
        public static func italic(
            text: String,
            endWithDefault: Bool = true
        ) -> String {
            decorate(text: text, ansis: [.italicFont], endWithDefault: endWithDefault)
        }
        
        /// Decorates `text` in ***bold+italic*** style.
        /// - Parameter text: The text to decorate
        /// - Returns: A `String` containing `ANSI` codes for rending on command line.
        @available(*, renamed: "decorate(text:style:endWithDefault:)", message: "Use ANSI.Style to express combinations of ANSI codes")
        public static func boldItalic(
            text: String,
            endWithDefault: Bool = true
        ) -> String {
            decorate(text: text, ansis: [.boldFont, .italicFont], endWithDefault: endWithDefault)
        }
    }
}

#warning(
    """
    TODO: zakkhoyt - Create library for writing help
    """
)
//    Create library for writing help screens so that they are parseable by compinit/compgen
//    https://github.com/zsh-users/zsh-completions/blob/master/zsh-completions-howto.org
//    https://github.com/zsh-users/zsh/blob/master/Etc/completion-style-guide
//    https://github.com/scriptingosx/mac-zsh-completions
//
// USAGE: ascii-table-parser [-x] [-d] [-o] [-b] [--rows <rows>] [--columns <columns>]
//
// OPTIONS:
//   -x                      Include hexadecimal representation.
//   -d                      Include decimal representation.
//   -o                      Include octal representation.
//   -b                      Include binary representation.
//   --rows <rows>           (default: 16)
//   --columns <columns>     (default: 4)
//   -h, --help              Show help information.
extension ANSI.UI {
    #warning("TODO: zakkhoyt - Use swift builders?")
    
    /// Use to build commmand line help screens
    public enum Help {
        public static func overview(
            summary: String
        ) -> String {
            """
            OVERVIEW:
            
            \(tab)\(summary)
            
            """
        }
        
        public static func usage(
            summary: String
        ) -> String {
            """
            USAGE:
            
            \(tab)\(summary)
            
            """
        }
        
        public static func options(
            summary: String,
            tuples: [(syntax: String, summary: String)]
        ) -> String {
            """
            OPTIONS:
            
            \(tab)\(summary)
            
            \(
                tuples.map {
                    option(syntax: $0.syntax, summary: $0.summary)
                }.joined(separator: "\n")
            )
            """
        }
        
        public static func option(
            syntax: String,
            summary: String
        ) -> String {
            """
            \("\(tab)\(bold(text: syntax))".padded(length: 32, endfix: .suffix))\("\(tab)\(tab)\(summary)")
            """
        }
        
        public static func header1(
            text: String
        ) -> String {
            "\(bold(text: text))"
        }
        
        public static func header2(
            text: String
        ) -> String {
            "\(tab)\(bold(text: text))"
        }
        
        public static func header3(
            text: String
        ) -> String {
            "\(tab)\(tab)\(bold(text: text))"
        }
    }
}

extension ANSI.UI {
    public enum Component {
        /// Presents a menu on stdout.
        /// User picks an entry using arrow keys.
        /// Selected value is returned as a `String`
        public static func menu(
            title: String?,
            items: [String]
        ) async throws -> String? {
            #warning("TODO: zakkhoyt - Implement an ANSI picker menu")
            // // 1
            
            logger.debug("Picker time!")
            var headerLines: [String] = []
            ////            echo -e "\x1B[91mred\x1B[0m default. \x1B[93myellow"
            ////            echo -d "\u{1B}[91mred\u{1B}[0m default. \u{1B}[93myellow"
            ////            echo -e "more text here. What color?"
//            headerLines.append("\u{1B}[91mred\u{1B}[0m default. \u{1B}[93myellow")
            
            if let title {
                headerLines.append(title)
                headerLines.append("")
            }
            
            headerLines.enumerated().forEach {
                FileDescriptor.stdout.write($0.element)
            }
            items.enumerated().forEach {
                // FileDescriptor.stdout.write("  \(ANSI.UI.decorate(text: "\($0.offset + 1)", style: .boldItalic)): \($0.element)")
                FileDescriptor.stdout.write("\($0.offset + 1):  \($0.element)")
            }
            
            #warning("FIXME: zakkhoyt - We can use alternate keys until we figrue out arrows. ")
            let validAnswers = (1...items.count).map { "\($0)" }
            while true {
                let r = try await FileDescriptor.stdin.read().replacingOccurrences(of: "\n", with: "")
                
//                FileDescriptor.logger.write("user entered: \(r)")
                
                if validAnswers.contains(r) {
                    logger.debug("[ANSI.UI.Picker] user selected item # \(r)")
                    if let i = Int(r), i < items.count {
                        logger.debug("[ANSI.UI.Picker] user selected item # \(i): \(items[i])")
                    } else {
                        logger.error("[ANSI.UI.Picker] user selected item # \(r), but coulnd't look up item")
                    }
                    break
                }
                
                logger.debug("[ANSI.UI.Picker] user entered invalid choice: \(r)")
                
                // cursorOff()
                logger.debug("Hiding cursor")
                FileDescriptor.stdout.write("\(ANSI.UI.decorate(text: "", items: [.init(.cursorHide)], endWithDefault: false))")
            }
            
//            items.forEach(<#T##body: (String) throws -> Void##(String) throws -> Void#>)
            
            // // 2
            // moveLineDown()
            
            // // 3
            // write("◆".foreColor(81).bold)
            
            // // 4
            // moveRight()
            
            // write(title)
            
            return "TODO: implement \(#function)"
        }
    }
}
