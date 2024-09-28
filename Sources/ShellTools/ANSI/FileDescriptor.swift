//
//  FileDescriptor.swift
//
//
//  Created by Zakk Hoyt on 1/10/24.
//

import Foundation

// @available(*, deprecated: "Use FileDescriptor")
@available(*, deprecated, message: "Please adopt one of the other syntax flavors")
public typealias fd = FileDescriptor

#warning(
    """
    IDEA: zakkhoyt - How to get better syntax for consumption?
    
    // Could use globals...
    public let stdout = FileDescriptor.stdout
    public let stderr = FileDescriptor.stderr
    public let stdin = FileDescriptor.stdin
    public let stdlog = FileDescriptor.stdlog
    // EX:
    stdout.write("")
    
    // Could use a typealias
    public typealias std = FileDescriptor
    // And renames (FileDescriptor.stdout -> .out, etc..)
    // EX:
    std.out.write("")
    """
)

/// ## References
///
/// - SeeAlso; `FileHandle.standardInput.availableData`
///
///
public final class FileDescriptor {
    public static let stdout = FileDescriptor(toStdErr: false)
    public static let stderr = FileDescriptor(toStdErr: true)
    public static let stdin = StandardIn()
    public static let stdlog = FileDescriptor(toStdErr: true, prefixes: [.yellowForeground])
    
    private let standardError: StandardError?
    private let prefixes: [ANSI]
    
    private init(
        toStdErr: Bool,
        prefixes: [ANSI] = []
    ) {
        if toStdErr {
            self.standardError = StandardError()
        } else {
            self.standardError = nil
        }
        self.prefixes = prefixes
    }
    
    public func write(_ message: String = "") {
        let prettyMessage = ANSI.UI.decorate(text: message, ansis: prefixes)
        if var standardError {
            Swift.print(prettyMessage, to: &standardError)
        } else {
            Swift.print(prettyMessage)
        }
    }
    
    public func write(_ lines: [String] = []) {
        write(lines.joined(separator: "\n"))
    }
    
    class StandardError: TextOutputStream {
        static var shared = StandardError()
        
        func write(_ string: String) {
            do {
                try FileHandle.standardError.write(contentsOf: Data(string.utf8))
            } catch {
                preconditionFailure("Failed tto write to standardError")
            }
        }
    }
    
    #warning("FIXME: zakkhoyt - Move this to DocC article")
    /// # References
    ///
    /// * [stdin article](https://dev.to/rithvik78/reading-from-the-standard-input-stdin-in-swift-19n6)
    ///
    /// ## References (detecting arrow keys)
    ///
    /// * [StackOverflow](https://stackoverflow.com/questions/24004776/input-from-the-keyboard-in-command-line-application)
    /// * [RawMode](https://bitbucket.org/jeremy-pereira/linenoise-swift-utf8/src/master/Sources/linenoise/Terminal.swift)
    ///
    /// ### ncurses
    ///
    /// * [NCurses video](https://www.youtube.com/watch?v=3YiPdibiQHA)
    ///     * [timestamped](https://youtu.be/3YiPdibiQHA?t=319)
    /// * [Swift+C Package](https://github.com/rderik/SwiftCursesTerm/tree/main/Sources)
    ///
    /// ### Getting Input / Keystrokes
    /// * [Getting Input](https://dev.iachieved.it/iachievedit/ncurses-with-swift-on-linux/)
    /// (scroll down to `Getting Input with getch`)
    /// * [rderik](https://rderik.com/blog/building-a-text-based-application-using-swift-and-ncurses/)
    /// (scroll to `Creating the Controller`)
    /// * [swift + c++](https://stackoverflow.com/a/422805/8038820)
    public class StandardIn {
        private let listener = HIDCGEventListener()
        public enum Error: Swift.Error {
            case readFailed
        }
        
        public func read() async throws -> String {
            if let str = readLine(strippingNewline: true) {
                debugPrint("did read from stdin: \(str)")
                return str
            } else {
                debugPrint("[ERROR] failed to read from stdin")
                throw Error.readFailed
            }
        }
        
        public func listen() async throws -> String {
            try await withCheckedThrowingContinuation { continuation in
                do {
                    try listener.start { event in
                        logger.debug("keypress callback: \(event)")
                        continuation.resume(with: .success(event))
                    }
                } catch {
                    continuation.resume(throwing: error)
                }
            }
        }
        
        public func _read_v2() -> String? {
            logger.debug("stdin.listen() called. Waiting for input....")
            let value = input()
            logger.debug("stdin.listen() returned value: \(String(describing: value))")
            return value
            
            func input() -> String? {
                NSString(
                    data: FileHandle.standardInput.availableData,
                    encoding: NSUTF8StringEncoding
                ) as? String
            }
        }
        
//        func run() {
        ////            defer { term.shutdown() }
        ////            term.noDelay(true)
//            while (getch() != nil) {
//                let now = Date()
//                let easyFileUrlcalendar = Calendar.current
//
//                let hours = calendar.component(.hour, from: now)
//                let minutes = calendar.component(.minute, from: now)
//                let seconds = calendar.component(.second, from: now)
//                clockView.display(hours: hours, minutes: minutes, seconds: seconds)
//                napms(1000)
//            }
//        }
    }
}

// try keyboardMonitor.start(
//    captureType: .cgEventListener(
//        mask: [.keyDown, .keyUp, .flagsChanged],
//        scope: .global
//    )
// )
