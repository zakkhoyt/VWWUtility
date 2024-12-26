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
//    @available(iOS 16.0, *)
    var fileURL: URL {
        if #available(macOS 13.0, macCatalyst 16.0, iOS 16.0, *) {
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

#if os(macOS) 
//    @available(macOS 14.0, *) {
    @available(macOS 14.0, *)
    private static var homeDirectoryOfCurrentUser: String {

        FileManager.default.homeDirectoryForCurrentUser.absoluteString
            .replacingOccurrences(of: "file://", with: "")
            .trimSuffix(text: "/")
    }
#endif
}

extension String {
    func trimSuffix(text: String) -> String {
        if hasSuffix(text) {
            return String(prefix(count - text.count))
        }
        return self
    }
}

extension URL {
    /// Returns a file URL from path of type tilde (home dir), absolute (path starts with /), relative (to current dir)
    /// - Parameter path: The file path
    public static func easyFileUrl(
        path: String,
        isDirectory: Bool = false
    ) -> URL {
        let betterURL: URL = {
            if path.contains("~") {
                let expandedPath = NSString(string: path).expandingTildeInPath
                if #available(macOS 13.0,macCatalyst 16.0, iOS 16.0, *) {
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
                return URL(
                    fileURLWithPath: path,
                    isDirectory: isDirectory
                )
            } else {
                return URL(
                    fileURLWithPath: FileManager.default.currentDirectoryPath,
                    isDirectory: isDirectory
                ).appendingPathComponent(path)
            }
        }()
        
        // This step gets rid of somepath/1/2/../../subdir -> somepath/subdir
        // https://stackoverflow.com/a/40401137
        let url: URL = if #available(macCatalyst 16.0, iOS 16.0, *) {
            URL(fileURLWithPath: betterURL.path())
        } else {
            URL(fileURLWithPath: betterURL.path)
        }
        
        if #available(macOS 13.0, macCatalyst 16.0, iOS 16.0, *) {
            guard let canonicalPath = (try? url.resourceValues(forKeys: [.canonicalPathKey]))?.canonicalPath else {
                return url
            }
            return URL(filePath: canonicalPath)
        } else {
            return url
        }
    }
}
