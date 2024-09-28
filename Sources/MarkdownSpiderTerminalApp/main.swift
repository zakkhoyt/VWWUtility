#!/usr/bin/env -S swift-sh

/// When using Swift in a scripting environment, it is not normally possible to import
/// 3rd party packages. That's where [swift-sh](https://github.com/mxcl/swift-sh)
/// comes in. Notice the shebang above and the comments on come of the `import` statements
/// below. Together these trigger `swift-sh` to download/build/cache a copy when run as a script.
/// Also this does not interfere if you choose to compile this swift code to binary.
///
/// Trouble compling? Try `swift-sh --clean-cache`
//
/// This script is used to generate `index.md` files, recursively in every dir
///
/// **Examples**
///
/// ```sh
/// ```
///
/// **Examples (different paths)**s
///
/// ```sh
/// # Call Script directly
/// main.swift "write to stdout"
/// ```

/// This script uses a 3rd party Swift Script tool called [swift-sh](https://github.com/mxcl/swift-sh)
import ArgumentParser // git@github.com:apple/swift-argument-parser ~> 1.3
import Foundation
import BaseUtility // git@github.com:zakkhoyt/VWWUtility.git ~> main
import HatchTerminalTools // ../../../HatchTerminal
import os


private let logger = os.Logger(
    subsystem: "co.hatch",
    category: "ascii_table"
)

extension FixedWidthInteger {
    var decimalString: String {
        "\(self)"
    }
    
    var base10String: String {
        decimalString
    }
}

func log(
    _ message: String
) {
    FileDescriptor.stdout.write(message)
}

func log_se(
    _ message: String
) {
//    FileDescriptor.stderr.write("\(ANSI.UI.decorate(text: message, style: .boldItalic))")
    logger.debug("\(message, privacy: .public)")
}


enum OutputFormat: String, CaseIterable, ExpressibleByArgument {
    case markdown
    case yaml
}



struct MKDocsGenerator: ParsableCommand {
    enum Error: Swift.Error {
        case someError(message: String)
    }
    
    
    // MARK: Required Arguments
    
    @Option(
        name: .customLong("root-dir")
    )
    var directoryPath: String
    
    // MARK: Optional Arguments
    
    @Flag(
        name: .customLong("debug"),
        help: ArgumentHelp(
            "Print debug diagnostics to stderr."
        )
    ) var isDebugMode = false
    
    @Option
    var outputFormat: OutputFormat = .markdown
    
    @Option(
        name: .customLong("is-relative")
    )
    var relativeToDirectory: Bool = true
    
    @Option
    var indentPerLevel: Int = 2
    
    @Option
    var fileTypes: [String] = ["md", "markdown"]
    
    func run() throws {
        log_se("isDebugMode: \(isDebugMode)")
        log_se("relativeToDirectory: \(relativeToDirectory)")
        log_se("spacesPerTab: \(indentPerLevel)")
        log_se("fileTypes: \(fileTypes)")
        
        
        log_se("outputFormat: \(outputFormat)")
        let outputStyle: OutputStyle = switch outputFormat {
        case .markdown: .markdown(
            indentPerLevel: indentPerLevel
        )
        case .yaml: .yaml
        }
        log_se("outputStyle: \(outputStyle)")
        
        log_se("directoryPath: \(directoryPath)")
        let directoryURL = URL(fileURLWithPath: directoryPath)
        log_se("directoryURL: \(directoryURL)")
        
        var lines: [String] = []
        
        try FileInspector(
            outputStyle: outputStyle,
            fileTypes: fileTypes
        ).inspect(
            directoryURL: directoryURL,
            relativeToDirectoryURL: directoryURL,
            output: &lines
        )
        
        let outputFileContent: String = lines.joined(separator: "\n")
        log_se("")
        log_se("---- ---- ---- ---- ---- ---- Output (\(lines.count) lines)---- ---- ---- ---- ---- ----")
        log_se("")
        log(outputFileContent)
        log_se("")
        log_se("---- ---- ---- ---- ---- ---- Finished ---- ---- ---- ---- ---- ----")
                
        MKDocsGenerator.exit()
    }
}

enum OutputStyle: CustomStringConvertible {
    case markdown(
        indentPerLevel: Int
    )
    case yaml
    
    var description: String {
        switch self {
        case .markdown(let indentPerLevel):
            "markdown(indentPerLevel: \(indentPerLevel))"
        case .yaml:
            "yaml"
        }
    }
    
    func indent(
        level: Int
    ) -> String {
        switch self {
        case .markdown(indentPerLevel: let indentPerLevel):
            String(repeating: " ", count: level * indentPerLevel)
        case .yaml:
            ""
        }
    }
}

extension URL {
    var canonicalURL: URL {
        let url = URL.easyFileUrl(path: path)
        guard let canonicalPath = (
            try? url.resourceValues(
                forKeys: [.canonicalPathKey]
            )
        )?.canonicalPath else {
            return url
        }
        
        return URL(filePath: canonicalPath)
    }
    
    var canonicalPath: String {
        canonicalURL.path
    }
}

extension [URL] {
    var sortedCanonical: [URL] {
        sorted {
            $0.canonicalPath.lowercased() < $1.canonicalPath.lowercased()
        }
    }
}

class FileInspector {
    
    let outputStyle: OutputStyle
    let fileTypes: Set<String>
    
    init(
        outputStyle: OutputStyle,
        fileTypes: [String]
    ) {
        self.outputStyle = outputStyle
        self.fileTypes = Set<String>(fileTypes.map { $0.lowercased() })
    }
    
    func inspect(
        directoryURL: URL,
        relativeToDirectoryURL rootDirectoryURL: URL,
        output: inout [String],
        level: Int = 0
    ) throws {
        log_se("Inspecting dir: \(directoryURL.path) level: \(level)")

        let urls = try FileManager.default.contentsOfDirectory(
            at: directoryURL,
            includingPropertiesForKeys: [
                .isDirectoryKey,
                .isRegularFileKey,
                .isPackageKey,
                .pathKey,
                .fileSizeKey
            ],
            options: [FileManager.DirectoryEnumerationOptions.skipsHiddenFiles]
        )

        let fileURLs: [URL] = try urls.filter {
            let fileAttributes = try $0.resourceValues(forKeys: [.isRegularFileKey])
            guard let isRegularFile = fileAttributes.isRegularFile, isRegularFile == true else {
                return false
            }

            let fileExtension: String = $0.pathExtension
            guard fileTypes.contains(fileExtension) else {
                log_se("File type not supported: \($0.lastPathComponent) (\($0.path))")
                return false
            }
            
            return true
        }.sortedCanonical
        
        let directoryURLs: [URL] = try urls.filter {
            let fileAttributes = try $0.resourceValues(forKeys: [.isDirectoryKey])
            guard let isDirectory = fileAttributes.isDirectory, isDirectory == true else {
                return false
            }
            
            if $0.lastPathComponent.hasPrefix(".") {
                log_se("Hidden directory: \($0.lastPathComponent) \($0.path)")
                return false
            }
            log_se("Not Hidden directory: \($0.lastPathComponent) \($0.path)")
            
            return true
        }.sortedCanonical
        
        
        let dirName = directoryURL.lastPathComponent
        let dirPathRelative = directoryURL.path.replacingOccurrences(
            of: "\(rootDirectoryURL.path)/",
            with: ""
        )
        
        let line = {
            switch self.outputStyle {
            case .markdown:
                let indent = self.outputStyle.indent(level: level)
//                return "\(indent)* [D: \(dirPathRelative)](\(directoryURL.path))"
                return "\(indent)* [<kbd>\(directoryURL.lastPathComponent)</kbd>/](\(directoryURL.path))"
            case .yaml:
                // EX: '  - Notes: notes/index.md'
                return "  - \(dirName): \(dirPathRelative)/index.md"
            }
        }()
        output.append(line)
        log_se(line)
        

        
        
        let fileLines: [String] = fileURLs.compactMap { [weak self] url in
            guard let self else { return nil }
            let line = {
                let fileName = url.lastPathComponent
                let filePathRelative = url.path.replacingOccurrences(
                    of: "\(rootDirectoryURL.path)/",
                    with: ""
                )
                
                switch self.outputStyle {
                case .markdown:
                    let indent = self.outputStyle.indent(level: level + 1)
//                    return "\(indent)* [F: \(filePathRelative)](\(url.path))"
                    return "\(indent)* [\(url.lastPathComponent)](\(url.path))"
                case .yaml:
                    // EX: '  - Notes: notes/index.md'
                    return "  - \(fileName): \(filePathRelative)"
                }
            }()
            output.append(line)
            log_se(line)
            return line
        }
#warning("TODO: zakkhoyt - write index.md into each directory. Markdown to all subdirs")
//        let indexMarkdownURL = directoryURL.appendingPathComponent("index.md")
//        try fileLines.joined(separator: "\n").write(to: indexMarkdownURL, atomically: false, encoding: .utf8)
        
        
        try directoryURLs.forEach { [weak self] url in
            guard let self else { return }
            try inspect(
                directoryURL: url,
                relativeToDirectoryURL: rootDirectoryURL,
                output: &output,
                level: level + 1
            )
        }
    }
}

MKDocsGenerator.main()

/// This keeps the script open so asyncronous code can be executed.
/// To end call `os.exit(UInt8)` or `Self.exit(withError: Error?)`
RunLoop.main.run()
