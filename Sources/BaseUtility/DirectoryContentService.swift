//
//  DirectoryContentService.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 1/13/25.
//

import Foundation

public struct FileHierarchyItem {
    public enum Error: Swift.Error {
        case missingURLResource(URL, URLResourceKey)
        case missingURLResources(URL, [URLResourceKey])
    }
    
    public enum DisplayFormat: CustomStringConvertible {
        case eza
        
        public var description: String {
            switch self {
            case .eza: "eza"
            }
        }
    }
    
    public enum FileKind {
        case directory(isSymbolicLink: Bool)
        case regularFile(sizeInBytes: UInt64, isAliasFile: Bool)
    }


    static let fileKindSystemResourceKeys: [URLResourceKey] = [
        .isDirectoryKey,
        .isRegularFileKey
    ]
    
    static let directoryResourceKeys: [URLResourceKey] = [
        .isSymbolicLinkKey
    ]
    
    static let regularFileResourceKeys: [URLResourceKey] = [
        .isAliasFileKey,
        .fileSizeKey // bytes
    ]
        
    static let commonRequiredResourceKeys: [URLResourceKey] = [
        .pathKey,
        .canonicalPathKey,
        .addedToDirectoryDateKey,
        .contentModificationDateKey,
        .creationDateKey,
    ]
    
    static let privacyResourceKeys: [URLResourceKey] = [
        .isExcludedFromBackupKey,
        .isHiddenKey
    ]

    static let otherResourceKeys: [URLResourceKey] = [
        .isPurgeableKey,
        .fileProtectionKey,
        .fileSecurityKey,
        .isPackageKey,
        .ubiquitousItemIsExcludedFromSyncKey,
    ]

    static let resourceKeys: [URLResourceKey] = fileKindSystemResourceKeys
        + commonRequiredResourceKeys
        + directoryResourceKeys
        + fileKindSystemResourceKeys
        + privacyResourceKeys
        + otherResourceKeys

    public let name: String
    public let url: URL
    
    
    // File Kind
    public let fileKind: FileKind
    
    // Common
    
    public let dateAddedToDirectory: Date
    public let dateCreated: Date
    public let dateModified: Date
    
    public let path: String
    public let canonicalPath: String
    
    
    public var isDirectory: Bool {
        switch fileKind {
        case .directory:
            true
        case .regularFile:
            false
        }
    }
    
    public var isRegularFile: Bool {
        switch fileKind {
        case .directory:
            false
        case .regularFile:
            true
        }
    }
    
//        public var isAlias: Bool? {
//            url.resourceValue(
//                key: .isAliasFileKey
//            )
//        }

    public var urlResourcesDescription: String {
        let keys = Self.fileKindSystemResourceKeys + Self.privacyResourceKeys
        let dict: [String: any CustomStringConvertible] = keys.reduce(into: [:]) {
            $0[$1.rawValue] = url.resourceValue(key: $1) ?? "NOPE!"
        }
        return dict.listDescription(separator: "\n\t")
    }

    init(
        name: String,
        url: URL
    ) throws {
        self.name = name
        self.url = url
        
        if let isDirectory: Bool = url.resourceValue(key: .isDirectoryKey), isDirectory == true {
            guard let isSymbolicLink: Bool = url.resourceValue(key: .isSymbolicLinkKey) else {
                let error = Error.missingURLResource(url, .isSymbolicLinkKey)
                logger.error("\(error.localizedDescription)")
                throw error
            }
            
            self.fileKind = .directory(
                isSymbolicLink: isSymbolicLink
            )
        } else if let isRegularFile: Bool = url.resourceValue(key: .isRegularFileKey), isRegularFile == true {
            // Dirs dont' have a fileSize
            guard let fileSizeNumber: NSNumber = url.resourceValue(key: .fileSizeKey) else {
                let error = Error.missingURLResource(url, .fileSizeKey)
                logger.error("\(error.localizedDescription)")
                throw error
            }
            
            guard let isAliasFile: Bool = url.resourceValue(key: .isAliasFileKey) else {
                let error = Error.missingURLResource(url, .isAliasFileKey)
                logger.error("\(error.localizedDescription)")
                throw error
            }

            self.fileKind = .regularFile(
                sizeInBytes: fileSizeNumber.uint64Value,
                isAliasFile: isAliasFile
            )
        } else {
            let error = Error.missingURLResources(url, [.isDirectoryKey, .isRegularFileKey])
            logger.error("\(error.localizedDescription)")
            throw error
        }

        // common

        guard let path: String = url.resourceValue(key: .pathKey) else {
            let error = Error.missingURLResource(url, .pathKey)
            logger.error("\(error.localizedDescription)")
            throw error
        }
        self.path = path
        
        guard let canonicalPath: String = url.resourceValue(key: .canonicalPathKey) else {
            let error = Error.missingURLResource(url, .canonicalPathKey)
            logger.error("\(error.localizedDescription)")
            throw error
        }
        self.canonicalPath = canonicalPath
        
        guard let addedToDirectoryDate: Date = url.resourceValue(key: .addedToDirectoryDateKey) else {
            let error = Error.missingURLResource(url, .addedToDirectoryDateKey)
            logger.error("\(error.localizedDescription)")
            throw error
        }
        self.dateAddedToDirectory = addedToDirectoryDate
        
        guard let createdDate: Date = url.resourceValue(key: .creationDateKey) else {
            let error = Error.missingURLResource(url, .creationDateKey)
            logger.error("\(error.localizedDescription)")
            throw error
        }
        self.dateCreated = createdDate
        
        guard let modifiedDate: Date = url.resourceValue(key: .contentModificationDateKey) else {
            let error = Error.missingURLResource(url, .contentModificationDateKey)
            logger.error("\(error.localizedDescription)")
            throw error
        }
        self.dateModified = modifiedDate

        
//            let urlResourcesDescription = urlResourcesDescription
//            logger.debug("Created Item \(name):\n\t\(urlResourcesDescription)")
    }
}

public struct FileHierarchyService {
    public init() {}
    
    #warning("TODO: zakkhoyt - return a list of URLs or FileHierarchyItems")
    public func walkFileHierarchy(
        directoryURL: URL,
        recursive: Bool,
        asAbsolutePath: Bool = true,
        level: Int = 0,
        format: FileHierarchyItem.DisplayFormat = .eza
    ) throws {
        // Avoid having `//` in urls later
        let directoryPath = (directoryURL.path() + "/").replacingOccurrences(of: "//", with: "/")
        
        if level == 0 {
            logger.debug(
                "**** Walking dir: \(directoryPath)"
            )
        }
        
        let fileHierarchyItems: [FileHierarchyItem] = try retrieveContentItem(
            directoryURL: directoryURL,
            asAbsolutePath: asAbsolutePath,
            level: level
        )
        
        try fileHierarchyItems.enumerated().forEach {
            let index = $0
            let fileHierarchyItem = $1
            let directoryPath = directoryURL.path()
            let url = fileHierarchyItem.url
            let displayName = url.lastPathComponent
            let relativePath = asAbsolutePath ? url.path : url.path.replacingOccurrences(of: "\(directoryPath)", with: "")
            // ```sh
            //     .
            // ├── 240825_141507.txt
            // ├── 240825_142707.txt
            // ├── 240825_143038.txt
            // ├── 240825_144910
            // │  ├── 240825_144910.txt
            // │  └── _240825_144910
            // │     ├── 240825_144910.txt
            // │     └── _240825_144910
            // │        └── 240825_144910.txt
            // ├── _240825_144910
            // │  └── 240825_144910.txt
            // └── FILE_PROVIDER.md
            // ```
            
            #warning("TODO: zakkhoyt - add `.` or initial absolute")
            let commonPrefix = "[L:\("\(level)".padded(length: 2, character: "0"))] "
            let dirIndentPrefix = level > 0 ? "│  " : ""
            let fileIndentPrefix = level > 0 ? "│  " : ""
            
            let dirIndentCore = String(repeating: "   ", count: Swift.max(0, level - 1))
            let fileIndentCore = String(repeating: "   ", count: Swift.max(0, level - 1))
            let isLastElement = index == fileHierarchyItems.count - 1
            let dirIndentPostfix = isLastElement ? "└── " : "├── "
            let fileIndentPostfix = dirIndentPostfix
            
            let dirIndent = [dirIndentPrefix, dirIndentCore, dirIndentPostfix].joined()
            let fileIndent = [fileIndentPrefix, fileIndentCore, fileIndentPostfix].joined()
            
            if fileHierarchyItem.isDirectory {
                let line = "\(dirIndent)\(displayName)    **** D:\(commonPrefix)"
                print(line)
                
                if recursive {
                    try walkFileHierarchy(
                        directoryURL: directoryURL.appendingPathComponent(relativePath),
                        recursive: recursive,
                        asAbsolutePath: asAbsolutePath,
                        level: level + 1
                    )
                }
            } else {
                let line = "\(fileIndent)\(displayName)    **** f:\(commonPrefix)"
                print(line)
            }
        }
    }
    
    func retrieveContentItem(
        directoryURL: URL,
        asAbsolutePath: Bool = true,
        level: Int
    ) throws -> [FileHierarchyItem] {
        do {
            // Get the directory contents urls (including subfolders urls)
            return try FileManager.default.contentsOfDirectory(
                at: directoryURL,
                includingPropertiesForKeys: FileHierarchyItem.resourceKeys,
                options: [
                    .skipsSubdirectoryDescendants // Want manual control here
                ]
            )
            .sorted {
                // Default order for `eza -T`
                $0.lastPathComponent.caseInsensitiveCompare($1.lastPathComponent) == .orderedAscending
                
                //                    // Case sensitive
                //                    $0.lastPathComponent < $1.lastPathComponent
            }
            .compactMap { url in
                do {
                    return try FileHierarchyItem(
                        name: url.deletingPathExtension().lastPathComponent,
                        url: url
                    )

                } catch {
                    logger.fault("\(error.localizedDescription)")
                    throw error

                }
            }
        } catch {
            logger.fault("\(error.localizedDescription)")
            throw error
        }
        
        //        let sortedByCreateDate = output.sorted { item1, item2 -> Bool in
        //            item1.createDate > item2.createDate
        //        }
        //
    }
}

public struct DirectoryContentFormatter {
    public enum DisplayFormat: CustomStringConvertible {
        case eza
        
        public var description: String {
            switch self {
            case .eza: "eza"
            }
        }
    }

}

/// ## References
///
/// * [StackOverflow](https://stackoverflow.com/questions/33337721/check-if-file-is-alias-swift)
///
extension URL {
    func resourceValue<T: Any>(
        key: URLResourceKey
    ) -> T? {
        do {
            return try (self as NSURL).resourceValues(forKeys: [key])[key] as? T
        } catch {
            logger.fault("\(error.localizedDescription)")
            return nil
        }
    }
}

