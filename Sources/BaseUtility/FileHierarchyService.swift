//
//  DirectoryContentService.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 1/13/25.
//

import Foundation

public struct FileHierarchyService {
    public init() {}
    
    public func walkFileHierarchy(
        directoryURL: URL,
        isRecursive: Bool,
        asAbsolutePath: Bool = true,
        level: Int = 0,
        format: DisplayFormat = .find
    ) throws -> [Item] {
        let baseDirectoryPath = directoryURL.path.removingPercentEncoding ?? directoryURL.path
        // Avoid having `//` in urls later
        let directoryPath = (baseDirectoryPath + "/").replacingOccurrences(of: "//", with: "/")

        
        if level == 0 {
            logger.debug(
                "**** Walking dir: \"\(directoryPath)\""
            )
        }
        
        let fileHierarchyItems: [Item] = try retrieveContentItem(
            directoryURL: directoryURL,
            asAbsolutePath: asAbsolutePath,
            level: level
        )
        
//        try fileHierarchyItems.enumerated().forEach {
        return try fileHierarchyItems.enumerated().reduce(
            into: []
        ) { partialResult, iter /*EnumeratedSequence<[Item]>.Iterator.Element*/ in

            let index = iter.offset
            
            let fileHierarchyItem = iter.element
            let directoryPath = directoryURL.path
            let url = fileHierarchyItem.url
            
#warning("TODO: zakkhoyt - add `.` or initial absolute")
            let commonPrefix = "[L:\("\(level)".padded(length: 2, character: "0"))] "
            

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
        
//            switch format {
//            case .eza:
//                let displayName = url.lastPathComponent
//                
//                let dirIndentPrefix = level > 0 ? "│  " : ""
//                let fileIndentPrefix = level > 0 ? "│  " : ""
//                
//                let dirIndentCore = String(repeating: "   ", count: Swift.max(0, level - 1))
//                let fileIndentCore = String(repeating: "   ", count: Swift.max(0, level - 1))
//                let isLastElement = index == fileHierarchyItems.count - 1
//                let dirIndentPostfix = isLastElement ? "└── " : "├── "
//                let fileIndentPostfix = dirIndentPostfix
//                let dirIndent = [dirIndentPrefix, dirIndentCore, dirIndentPostfix].joined()
//                let fileIndent = [fileIndentPrefix, fileIndentCore, fileIndentPostfix].joined()
//                
//                if fileHierarchyItem.isDirectory {
//                    let line = "\(dirIndent)\(displayName)    **** D:\(commonPrefix)"
//                    print(line)
//                    
//                } else {
//                    let line = "\(fileIndent)\(displayName)    **** f:\(commonPrefix)"
//                    print(line)
//                }
//            case .find:
//                let displayName = url.path
//                if fileHierarchyItem.isDirectory {
//                    let line = "\(displayName)/    **** D:\(commonPrefix)"
//                    print(line)
//                    
//                } else {
//                    let line = "\(displayName)    **** f:\(commonPrefix)"
//                    print(line)
//                }
//            }
            
            partialResult.append(fileHierarchyItem)
            
            if fileHierarchyItem.isDirectory, isRecursive {
                let recursiveItems: [Item] = try walkFileHierarchy(
                    directoryURL: fileHierarchyItem.url,
                    isRecursive: isRecursive,
                    asAbsolutePath: asAbsolutePath,
                    level: level + 1
                )
                partialResult.append(contentsOf: recursiveItems)
                return
            } else {
                // Done with this dir
            }
        }
    }
    
    func retrieveContentItem(
        directoryURL: URL,
        asAbsolutePath: Bool = true,
        level: Int
    ) throws -> [Item] {
        do {
            // Get the directory contents urls (including subfolders urls)
            return try FileManager.default.contentsOfDirectory(
                at: directoryURL,
                includingPropertiesForKeys: Item.resourceKeys,
                options: [
                    .skipsSubdirectoryDescendants, // Want manual control here
                    .producesRelativePathURLs
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
                    return try Item(
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

extension FileHierarchyService {
    public enum DisplayFormat: CustomStringConvertible {
        case eza
        case find
        //            case lsOne
        
        public var description: String {
            switch self {
            case .eza: "eza"
            case .find: "find * -type f"
                //                case .lsOne: "ls -1"
            }
        }
    }
}

extension FileHierarchyService {
    public struct Item {
        public enum Error: Swift.Error {
            case missingURLResource(URL, URLResourceKey)
            case missingURLResources(URL, [URLResourceKey])
        }
        
        public enum FileKind {
            case directory(isSymbolicLink: Bool)
            case regularFile(sizeInBytes: UInt64, isAliasFile: Bool, fileExtension: String)
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
                
        /// Returns the path component of the URL if present, otherwise returns an empty string.
        /// - note: This function will resolve against the base `URL`.
        /// - Parameter percentEncoded: Whether the path should be percent encoded,
        /// - Returns: The path component of the URL.
        public func path(percentEncoded: Bool) -> String {
            url.path(percentEncoded: false)
        }
        
        /// Returns the path components of the URL, or an empty array if the path is an empty string.
        public var pathComponents: [String] {
            url.pathComponents
        }

        /// Returns the last path component of the URL, or an empty string if the path is an empty string.
        public var lastPathComponent: String {
            url.lastPathComponent
        }

        
        /// Returns the path extension of the URL, or an empty string if the path is an empty string.
        public var fileExtension: String {
            url.pathExtension
        }
        
        /// Returns the file name without extension
        public var fileBasename: String {
            url.deletingPathExtension().lastPathComponent
        }
        
#warning("FIXME: zakkhoyt - return Item")
        public var parentDirectoryURL: URL {
            url.deletingLastPathComponent()
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
                    isAliasFile: isAliasFile,
                    fileExtension: url.pathExtension
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
}


//ext
//public struct DirectoryContentFormatter {
//    public enum DisplayFormat: CustomStringConvertible {
//        case eza
//        
//        public var description: String {
//            switch self {
//            case .eza: "eza"
//            }
//        }
//    }
//
//}

