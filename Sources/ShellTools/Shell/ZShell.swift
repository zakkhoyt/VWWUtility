//
//  File 2.swift
//
//
//  Created by Zakk Hoyt on 6/14/24.
//

import Foundation
#if os(macOS)

import Foundation

public typealias ZShell = SwiftShell


public enum SwiftShell: Shellable {
    // MARK: Nested Types
    
    
//    /// Executes a command in zshell
//    /// - Parameter stdin: a list of stdin commands
//    /// - Returns: stdout
//    public func exec(
//        commands stdin: [String]
//    ) throws -> String {
//        let stdout = try Self.exec(commands: stdin)
//
//        let stdinFormatted = stdin.joined(separator: " ")
//        let stdoutFormatted = stdout
//        print("stdin: \(stdinFormatted)")
//        print("stdout: \(stdoutFormatted)")
//
//        let dateString: String = {
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "hh:mm:ss"
//            return dateFormatter.string(from: Date())
//        }()
//
//        let formattedOutput = """
//        ```
//        \(dateString) > \(stdinFormatted)
//        \(stdoutFormatted)
//        ```
//        """
//        return formattedOutput
//    }
}

extension SwiftShell {
    public static func exec(
        commands stdin: [String]
    ) throws -> String {
        guard !stdin.isEmpty else {
            throw ShellInputError.stdinEmpty
        }
        
        guard let stdout = legacyExecute(stdin) else {
            throw ShellInputError.noStdOut
        }
        
        return stdout
    }
}
#endif
