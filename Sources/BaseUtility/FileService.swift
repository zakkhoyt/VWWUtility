//
//  FileService.swift
//
//
//  Created by Zakk Hoyt on 10/14/21.
//

import Foundation

public enum FileService {
    public enum Error: LocalizedError {
        case purgeDirectory(message: String, url: URL)
        
        public var errorDescription: String? {
            switch self {
            // case .custom(let message):
            case .purgeDirectory(let message, let url):
                "\(message): \(url.path)"
            }
        }
    }
    
    public static func dirExists(path: String) -> Bool {
        dirExists(url: URL.easyFileUrl(path: path, isDirectory: true))
    }
    
    public static func dirExists(url: URL) -> Bool {
        // FileManager.default.fileExists(atPath: url.path) && url.hasDirectoryPath
        FileManager.default.fileExists(atPath: url.path) // && url.hasDirectoryPath
    }
    
    public static func fileExists(path: String) -> Bool {
        fileExists(url: URL.easyFileUrl(path: path))
    }
    
    public static func fileExists(url: URL) -> Bool {
        FileManager.default.fileExists(atPath: url.path)
    }
    
    public static func ensureDirectoryExists(
        url: URL
    ) throws {
        guard !FileManager.default.fileExists(atPath: url.path) else {
            return
        }
        
        try FileManager.default.createDirectory(
            at: url,
            withIntermediateDirectories: true,
            attributes: [:]
        )
        
        logger.debug("\(LogHelper.callerData()) - Did create directory at \(url.path)")
    }
    
    public static func createFile(
        path: String,
        content: String
    ) throws {
        try content.write(toFile: path, atomically: true, encoding: .utf8)
    }
    
    public static func createFile(
        url: URL,
        content: String
    ) throws {
        try content.write(to: url, atomically: true, encoding: .utf8)
    }
    
    /// Deletes and recreates a directory.
    /// - Parameter url: The url of directory to create.
    @available(*, renamed: "purgeDirectory(url:)")
    public static func createDirectory(
        url: URL
    ) throws {
        try purgeDirectory(url: url)
    }
    
    /// Purges a directory by deleting and re-creating int
    /// - Parameter url: The url of directory to create.
    public static func purgeDirectory(
        url: URL
    ) throws {
        try purgeDirectory(path: url.path)
    }
    
    /// Purges a directory by deleting and re-creating int
    /// - Parameter path: The path of directory to create.
    public static func purgeDirectory(
        path: String
    ) throws {
        if dirExists(path: path) {
            try FileManager.default.removeItem(atPath: path)
        }
        
        try FileManager.default.createDirectory(
            atPath: path,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }

    public static func deleteFile(
        path: String
    ) throws {
        try FileManager.default.removeItem(atPath: path)
    }
    
    public static func deleteFile(
        url: URL
    ) throws {
        try FileManager.default.removeItem(at: url)
    }

    public static func copyFile(
        source sourceUrl: URL,
        dest destUrl: URL
    ) throws {
//        try FileManager.default.removeItem(at: destUrl)
        try FileManager.default.copyItem(at: sourceUrl, to: destUrl)
    }
}


extension String {
    var fileURL: URL {
        if #available(macOS 13.0, *) {
            URL(filePath: self, directoryHint: URL.DirectoryHint.checkFileSystem, relativeTo: nil)
        } else {
            URL(fileURLWithPath: self)
        }
    }
}

extension FileService {
    public static func isDirectoryEmpty(
        directory: String
    ) throws -> Bool {
        let safeDir = expand(path: directory)
        do {
            let contents = try FileManager.default.contentsOfDirectory(atPath: directory)
            if contents.isEmpty { return true }
            
            logger.debug("Found \(contents.count) items in directory: \(directory)")
            contents.forEach {
                logger.debug("  \($0)")
            }
            return false
        } catch {
            logger.error("\(error.localizedDescription)")
            throw error
        }
    }
}

extension FileService {
    public static func expand(path: String) -> String {
        NSString(string: path).expandingTildeInPath
    }
}

#if os(macOS)
extension FileService {
    private static var homeDirectoryOfCurrentUser: String {
        FileManager.default.homeDirectoryForCurrentUser.absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .trimSuffix(text: "/")
    }
}
#endif

extension String {
    func trimSuffix(text: String) -> String {
        if hasSuffix(text) {
            return String(prefix(count - text.count))
        }
        return self
    }
}

extension URL {
    /// A wrapper init which helps convert a `path` to an optimized `URL` of `fileURL`variety.
    ///
    /// - SeeAlso: ``URL/easyFileUrl(path:isDirectory:)``
    public init(safeFileURLFromPath path: String) {
        self = URL.easyFileUrl(path: path)
    }
    
    /// A wrapper init which helps convert a `url.path` to an optimized `URL` of `fileURL`variety.
    ///
    /// - SeeAlso: ``URL/easyFileUrl(path:isDirectory:)``
    public init(makeSafeFileURLFromURL url: URL) {
        self = URL.easyFileUrl(url: url)
    }

    /// A wrapper function which helps convert a `url.path` to an optimized `URL` of `fileURL`variety.
    ///
    /// - SeeAlso: ``URL/easyFileUrl(path:isDirectory:)``
    public static func easyFileUrl(
        url: URL,
        isDirectory: Bool = false
    ) -> URL {
        easyFileUrl(path: url.path, isDirectory: isDirectory)
    }
    
    /// A wrapper function which helps convert a `path` to a `URL` of file URL variety.
    ///
    /// - SeeAlso: ``URL/easyFileUrl(path:isDirectory:)``
    /// * Replaces tilde (`~`) with (User's HomeDir),
    /// * Autodetects absolute paths (starts with `/`),
    /// * Converts relative path to absolution
    /// * Shortens the number of dirs where possible
    ///
    /// - Parameter path: The file path
    ///
    /// The computation of `betterURL` does a lot to condition the URL into a fileSystem URL,
    /// Then the `canonicalPath` step does some additional conditioning.
    /// ```swift
    /// let beforeURL = ".../somepath/1/2/../../subdir` -> `.../somepath/subdir
    /// ```
    /// And also some redundancy which can be good).
    ///
    /// ## References
    ///
    /// * [StackOverflow](https://stackoverflow.com/a/40401137)
    ///
    public static func easyFileUrl(
        path: String,
        isDirectory: Bool = false
    ) -> URL {
        let betterURL = URL(
            fileURLWithPath: {
                if path.contains("~") {
                    // Replace ~ with Home dir where possible
                    let expandedPath = NSString(string: path).expandingTildeInPath
                    if #available(macOS 13.0, *) {
                        return URL(
                            filePath: expandedPath,
                            directoryHint: URL.DirectoryHint.checkFileSystem,
                            relativeTo: nil
                        )
                    } else {
                        return URL(
                            fileURLWithPath: expandedPath,
                            isDirectory: isDirectory
                        )
                    }
                } else if path.prefix(1) == "/" {
                    // AutoDetect if we should cast using fileURL
                    return URL(
                        fileURLWithPath: path,
                        isDirectory: isDirectory
                    )
                } else {
                    // Treat incoming path as relative to PWD
                    return URL(
                        fileURLWithPath: FileManager.default.currentDirectoryPath,
                        isDirectory: isDirectory
                    ).appendingPathComponent(path)
                }
            }().path
        )
        
        #warning(
            """
            FIXME: zakkhoyt - Add step to unwind symbolic links. 
            * EX: /var vs /private/var on iPhone 
            * maybe canonicalURL includes?
            """
        )
        
        #warning("FIXME: zakkhoyt - Handle `//` in URL/path")

        return betterURL.canonicalURL ?? betterURL
    }
    
    public var canonicalURL: URL? {
        // https://stackoverflow.com/a/40401137
        guard let canonicalPath = (try? resourceValues(forKeys: [.canonicalPathKey]))?.canonicalPath else {
            return nil
        }
        
        return URL(filePath: canonicalPath)

    }
    
#warning(
            """
            FIXME: zakkhoyt - new function, cleanURL
            * removes "//" from middle of path (filePath)
            * appendingPathComponent("Preferences")
            """
    )

    
}
