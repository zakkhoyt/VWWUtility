//
//  FileCrawler.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 1/13/25.
//

import Foundation

public struct FileCrawler {
    public init() {}
    
    public func walkFileHierarchy(
        directoryURL: URL,
        isRecursive: Bool,
        fileFilter: ((URL) -> Bool)? = nil,
        level: Int = 0
    ) throws -> [Item] {
//        let directoryURL: URL
//        switch item {
//        case .regularFile/*(let url, let sizeInBytes, let isAliasFile, let fileExtension)*/:
//            return []
//
//        case .directory(let url, let isSymbolicLink, let directoryItems, let fileItems):
//            directoryURL = url
//        }
        
        let baseDirectoryPath = directoryURL.path.removingPercentEncoding ?? directoryURL.path
        // Avoid having `//` in urls later
        let directoryPath = (baseDirectoryPath + "/").replacingOccurrences(of: "//", with: "/")

        
        if level == 0 {
            logger.debug(
                "**** Walking dir: \"\(directoryPath)\""
            )
        }
        
        let tuple = try retrieveContentURLs(
            directoryURL: directoryURL
        )
        let fileURLs: [URL] = tuple.fileURLs
        let directoryURLs: [URL] = tuple.directoryURLs
        
        
        
        let fileItems: [FileCrawler.Item] = try fileURLs.compactMap { url in
            guard let isHidden: NSNumber = url.resourceValue(key: .isHiddenKey) else {
                let error = Error.missingURLResource(url, .isHiddenKey)
                logger.error("\(error.localizedDescription)")
                throw error
            }
            
            if isHidden.boolValue == true {
    #warning("FIXME: zakkhoyt - do the same for dirs")
                logger.error("Skipping hidden file: \(url.path(percentEncoded: false))")
                return nil
            }
            
            guard url.isFileURL, url.hasDirectoryPath == false else {
                let error = Error.expectedFileURL(url)
                logger.error("\(error.localizedDescription)")
                throw error
            }
            
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
            
            if let passedFilter = fileFilter?(url) {
                if passedFilter == false {
                    logger.warning("Exclude fileURL because it failed the fileFilter: \(url.path(percentEncoded: false))")
                    return nil
                } else {
                    logger.debug("Included fileURL because it passes the fileFilter: \(url.path(percentEncoded: false))")
                }
            } else {
                logger.fault("Included fileURL because fileFilter is nil: \(url.path(percentEncoded: false))")
            }
            
            return .regularFile(
                url: url,
                sizeInBytes: fileSizeNumber.uint64Value,
                isAliasFile: isAliasFile,
                fileExtension: url.pathExtension
            )
        }
            
            
//        let fileItems: [Item] = try fileURLs.map { url in
//            
//            
//            
//            guard let isDirectory: Bool = url.resourceValue(key: .isDirectoryKey),
//                    isDirectory == true
//            else {
//                logger.error("")
//                return nil
//            }
//                guard let isSymbolicLink: Bool = url.resourceValue(key: .isSymbolicLinkKey) else {
//                    let error = Error.missingURLResource(url, .isSymbolicLinkKey)
//                    logger.error("\(error.localizedDescription)")
//                    throw error
//                }
////                self.fileKind = .directory(
////                    isSymbolicLink: isSymbolicLink
////                )
//                self = .directory(
//                    url: url,
//                    isSymbolicLink: isSymbolicLink,
//                    directoryItems: [],
//                    fileItems: []
//                )
//
//                
//            try Item(url: $0)
//        }
        
//        let dirItems: [Item] = try fileURLs.map {
//            try Item(url: $0)
//        }
        
        
//        try fileHierarchyItems.enumerated().forEach {
        let subdirectoryItems: [Item] = try directoryURLs.enumerated().reduce(
            into: []
        ) { partialResult, iter /*EnumeratedSequence<[Item]>.Iterator.Element*/ in

            let index = iter.offset
            
//            let fileHierarchyItem = iter.element
            //            let url = fileHierarchyItem.url
#warning("""
FIXME: zakkhoyt - renamame to subdirectoryURL
""")
//            let directoryPath = directoryURL.path
            let subdirectoryURL = iter.element
            

            
//#warning("TODO: zakkhoyt - add `.` or initial absolute")
//            let commonPrefix = "[L:\("\(level)".padded(length: 2, character: "0"))] "

//            if fileHierarchyItem.isDirectory, isRecursive {
            if isRecursive {
                let subdirectoryItems: [Item] = try walkFileHierarchy(
                    directoryURL: subdirectoryURL,
                    isRecursive: isRecursive,
                    fileFilter: fileFilter,
                    level: level + 1
                )
                partialResult.append(contentsOf: subdirectoryItems)
                return
            } else {
                // Done with this dir
            }
        }
        
        guard let isDirectory: Bool = directoryURL.resourceValue(key: .isDirectoryKey), isDirectory == true else {
            let error = Error.expectedDirectoryURL(directoryURL)
            logger.error("\(error.localizedDescription)")
            throw error
        }
        
        guard let isSymbolicLink: Bool = directoryURL.resourceValue(key: .isSymbolicLinkKey) else {
            let error = FileCrawler.Error.missingURLResource(directoryURL, .isSymbolicLinkKey)
            logger.error("\(error.localizedDescription)")
            throw error
        }
        
        let directoryItem: Item = .directory(
            url: directoryURL,
            isSymbolicLink: isSymbolicLink,
            subdirectoryItems: subdirectoryItems,
            fileItems: fileItems
        )
        return [directoryItem]
    }
    
    func retrieveContentURLs(
        directoryURL: URL
    ) throws -> (directoryURLs: [URL], fileURLs: [URL]) {
        do {
            let options: FileManager.DirectoryEnumerationOptions = [
                .skipsSubdirectoryDescendants, // Want manual control here
                .producesRelativePathURLs
            ]
            
            // Get the directory contents urls (including subfolders urls)
//            let directoryURLs = try FileManager.default.contentsOfDirectory(
//                at: directoryURL,
//                includingPropertiesForKeys: Item.directoryRsourceKeys,
//                options: options
//            )
//                .sorted {
//                    // Default order for `eza -T`
//                    $0.lastPathComponent.caseInsensitiveCompare($1.lastPathComponent) == .orderedAscending
//                }
//            
//            
//            let fileURLs = try FileManager.default.contentsOfDirectory(
//                at: directoryURL,
//                includingPropertiesForKeys: Item.fileResourceKeys,
//                options: options
//            )
//                .sorted {
//                    // Default order for `eza -T`
//                    $0.lastPathComponent.caseInsensitiveCompare($1.lastPathComponent) == .orderedAscending
//                }
//            
//            return (directoryURLs: directoryURLs, fileURLs: fileURLs)
            
            
            let urls = try FileManager.default.contentsOfDirectory(
                at: directoryURL,
                includingPropertiesForKeys: Item.allResourceKeys,
                options: options
            )
                .sorted {
                    // Default order for `eza -T`
                    $0.lastPathComponent.caseInsensitiveCompare($1.lastPathComponent) == .orderedAscending
                }
            let directoryURLs: [URL] = urls.filter { url in
                guard let number: NSNumber = url.resourceValue(key: .isDirectoryKey) else {
                    logger.fault("Failed to get resource for .isDirectoryKey for directoryURL: \(url.path(percentEncoded: false))")
                    return false
                }
                guard number.boolValue == true else {
//                    logger.warning("Excluding directoryURL because .isDirectoryKey == false \(url.path(percentEncoded: false))")
                    return false
                }
//                logger.debug("Including directoryURL: \(url.path(percentEncoded: false))")
                return true
            }
            let fileURLs: [URL] = urls.filter { url in
                guard let number: NSNumber = url.resourceValue(key: .isRegularFileKey) else {
                    logger.fault("Failed to get resource for .isDirectoryKey for fileURL: \(url.path(percentEncoded: false))")
                    return false
                }
                guard number.boolValue == true else {
//                    logger.warning("Excluding fileURL because .isRegularFileKey == false \(url.path(percentEncoded: false))")
                    return false
                }
//                logger.debug("Including fileURL: \(url.path(percentEncoded: false))")
                return true
            }


            return (directoryURLs: directoryURLs, fileURLs: fileURLs)
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

extension FileCrawler {
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

extension FileCrawler {
    public enum Error: Swift.Error {
        case missingURLResource(URL, URLResourceKey)
        case missingURLResources(URL, [URLResourceKey])
        case expectedDirectoryURL(URL)
        case expectedFileURL(URL)
    }
}


extension FileCrawler {
    public enum Item {
        case directory(url: URL, isSymbolicLink: Bool, subdirectoryItems: [Item], fileItems: [Item])
        case regularFile(url: URL, sizeInBytes: UInt64, isAliasFile: Bool, fileExtension: String)
        
        //        public enum FileKind {
        //            case directory(isSymbolicLink: Bool, subdirs: [Item], files: [Item])
        //            case regularFile(sizeInBytes: UInt64, isAliasFile: Bool, fileExtension: String)
        //        }
        
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
        
        static let directoryRsourceKeys: [URLResourceKey] = [
            commonRequiredResourceKeys,
            privacyResourceKeys,
            otherResourceKeys,
            directoryResourceKeys
        ].flatMap {
            $0
        }
        
        static let fileResourceKeys: [URLResourceKey] =  [
            commonRequiredResourceKeys,
            privacyResourceKeys,
            otherResourceKeys,
            fileKindSystemResourceKeys
        ].flatMap {
            $0
        }

        
        static let allResourceKeys: [URLResourceKey] = [
            commonRequiredResourceKeys,
            privacyResourceKeys,
            otherResourceKeys,
            directoryResourceKeys
        ].flatMap {
            $0
        }

        //        public let name: String
        //        public let url: URL
        
        
        //        // File Kind
        //        public let fileKind: FileKind
        
        // Common
        
        //        public let dateAddedToDirectory: Date
        //        public let dateCreated: Date
        //        public let dateModified: Date
        
        //        public let path: String
        //        public let canonicalPath: String
        //
        
        public var isDirectory: Bool {
            switch self {
            case .directory:
                true
            case .regularFile:
                false
            }
        }
        
        public var url: URL {
            switch self {
            case .directory(let url, let isSymbolicLink, let subdirs, let files):
                return url
            case .regularFile(let url, let sizeInBytes, let isAliasFile, let fileExtension):
                return url
            }
        }
        
        public var path: String {
            get throws {
                guard let path: String = url.resourceValue(key: .pathKey) else {
                    let error = Error.missingURLResource(url, .pathKey)
                    logger.error("\(error.localizedDescription)")
                    throw error
                    //                    return url.path(percentEncoded: false)
                }
                return path
            }
        }
        
        public var canonicalPath: String {
            get throws {
                guard let canonicalPath: String = url.resourceValue(key: .canonicalPathKey) else {
                    let error = Error.missingURLResource(url, .canonicalPathKey)
                    logger.error("\(error.localizedDescription)")
                    throw error
                }
                return canonicalPath
            }
        }
        
        public var addedToDirectoryDate: Date {
            get throws {
                guard let addedToDirectoryDate: Date = url.resourceValue(key: .addedToDirectoryDateKey) else {
                    let error = Error.missingURLResource(url, .addedToDirectoryDateKey)
                    logger.error("\(error.localizedDescription)")
                    throw error
                }
                return addedToDirectoryDate
            }
        }
        
        public var createdDate: Date {
            get throws {
                guard let createdDate: Date = url.resourceValue(key: .creationDateKey) else {
                    let error = Error.missingURLResource(url, .creationDateKey)
                    logger.error("\(error.localizedDescription)")
                    throw error
                }
                return createdDate
            }
        }
        
        public var modifiedDate: Date {
            get throws {
                guard let modifiedDate: Date = url.resourceValue(key: .contentModificationDateKey) else {
                    let error = Error.missingURLResource(url, .contentModificationDateKey)
                    logger.error("\(error.localizedDescription)")
                    throw error
                }
                return modifiedDate
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
        
        public var urlResourcesDescription: String {
            let keys = Self.fileKindSystemResourceKeys + Self.privacyResourceKeys
            let dict: [String: any CustomStringConvertible] = keys.reduce(into: [:]) {
                $0[$1.rawValue] = url.resourceValue(key: $1) ?? "NOPE!"
            }
            return dict.listDescription(separator: "\n\t")
        }
        
//        public static func directory(
//            url: URL
//        ) throws -> FileCrawler {
//        
//        }
//
//        init(
////            name: String,
//            url: URL
//        ) throws {
////            self.name = name
////            self.url = url
//            
//            if let isDirectory: Bool = url.resourceValue(key: .isDirectoryKey), isDirectory == true {
//                guard let isSymbolicLink: Bool = url.resourceValue(key: .isSymbolicLinkKey) else {
//                    let error = FileCrawler.Error.missingURLResource(url, .isSymbolicLinkKey)
//                    logger.error("\(error.localizedDescription)")
//                    throw error
//                }
////                self.fileKind = .directory(
////                    isSymbolicLink: isSymbolicLink
////                )
//                self = .directory(
//                    url: url,
//                    isSymbolicLink: isSymbolicLink,
//                    subdirectoryItems: [],
//                    fileItems: []
//                )
//            } else if let isRegularFile: Bool = url.resourceValue(key: .isRegularFileKey), isRegularFile == true {
//                // Dirs dont' have a fileSize
//                guard let fileSizeNumber: NSNumber = url.resourceValue(key: .fileSizeKey) else {
//                    let error = FileCrawler.Error.missingURLResource(url, .fileSizeKey)
//                    logger.error("\(error.localizedDescription)")
//                    throw error
//                }
//                
//                guard let isAliasFile: Bool = url.resourceValue(key: .isAliasFileKey) else {
//                    let error = FileCrawler.Error.missingURLResource(url, .isAliasFileKey)
//                    logger.error("\(error.localizedDescription)")
//                    throw error
//                }
//
////                self.fileKind = .regularFile(
////                    sizeInBytes: fileSizeNumber.uint64Value,
////                    isAliasFile: isAliasFile,
////                    fileExtension: url.pathExtension
////                )
//                
//                self = .regularFile(
//                    url: url,
//                    sizeInBytes: fileSizeNumber.uint64Value,
//                    isAliasFile: isAliasFile,
//                    fileExtension: url.pathExtension
//                )
//            } else {
//                let error = Error.missingURLResources(url, [.isDirectoryKey, .isRegularFileKey])
//                logger.error("\(error.localizedDescription)")
//                throw error
//            }
//
//            // common
//
//        }
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

