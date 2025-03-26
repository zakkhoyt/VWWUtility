//
//  FileCrawler.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 1/13/25.
//

import Foundation

public struct FileCrawler {
    public init() {}
    
    public static func contentsOfDirectory(
        directoryURL: URL,
        directoryFilter: ((URL) -> Bool)? = nil,
        fileFilter: ((URL) -> Bool)? = nil
    ) throws -> [URL] {
        let resourceKeys = Set<URLResourceKey>([.nameKey, .isDirectoryKey])
        guard let directoryEnumerator = FileManager().enumerator(
            at: directoryURL,
            includingPropertiesForKeys: Array(resourceKeys),
            options: .skipsHiddenFiles
        ) else {
            return []
        }
        
        let fileURLs: [URL] = directoryEnumerator.reduce(
            into: []
        ) { // partialResult, NSEnumerator.Element in
            guard case let url as URL = $1 else { return }
            
            guard let resourceValues: URLResourceValues = {
                do {
                    return try url.resourceValues(
                        forKeys: .allResourceKeys
                    )
                } catch {
                    logger.warning(
                        "Failed to fetch resourceKeys for url: \(url.absoluteString) with error: \(error.localizedDescription)"
                    )
                    return nil
                }
            }() else { return }
            
            guard let isDirectory = resourceValues.isDirectory else {
                logger.warning("Failed to fetch resourceKey: .isDirectory for url: \(url.absoluteString)")
                return
            }
            guard let isRegularFile = resourceValues.isRegularFile else {
                logger.warning("Failed to fetch resourceKey: .isRegularFile for url: \(url.absoluteString)")
                return
            }
            
            if isDirectory {
                if directoryFilter?(url) ?? true {
                    $0.append(url)
                } else {
                    logger.warning("Exclude dirURL because it failed the dirFilter: \(url.path(percentEncoded: false))")
                }
            } else if isRegularFile {
                if fileFilter?(url) ?? true {
                    $0.append(url)
                } else {
                    logger.warning("Exclude fileURL because it failed the fileFilter: \(url.path(percentEncoded: false))")
                }
            } else {
                logger.warning("Exclude url which is neither a directory or a regular file: \(url.absoluteString)")
            }
            
//            guard let isDirectory = resourceValues.isDirectory else {
//                logger.warning("Failed to fetch resourceKey: .isDirectory for url: \(url.absoluteString)")
//                return
//            }
//            guard !isDirectory else {
//                let includeDirectory = directoryFilter?(url) ?? true
//                if includeDirectory {
//                    $0.append(url)
//                }
//                return
//            }
//            guard let isRegularFile = resourceValues.isRegularFile else {
//                logger.warning("Failed to fetch resourceKey: .isRegularFile for url: \(url.absoluteString)")
//                return
//            }
//            guard !isRegularFile else {
//                let includeFile = fileFilter?(url) ?? true
//                if includeFile {
//                    $0.append(url)
//                }
//                return
//            }
            

            

            
//
//            
//            switch $1 {
//            case let url as URL:
//                do {
//                    let resourceValues = try url.resourceValues(
//                        forKeys: .allResourceKeys
//                    )
//                    guard let isDirectory = resourceValues.isDirectory else {
//                        logger.warning("Failed to fetch resourceKey: .isDirectory for url: \(url.absoluteString)")
//                        return
//                    }
//                    guard !isDirectory else {
//                        let includeDirectory = directoryFilter?(url) ?? true
//                        if includeDirectory {
//                            $0.append(url)
//                        }
//                        return
//                    }
//                    guard let isRegularFile = resourceValues.isRegularFile else {
//                        logger.warning("Failed to fetch resourceKey: .isRegularFile for url: \(url.absoluteString)")
//                        return
//                    }
//                    guard !isRegularFile else {
//                        let includeFile = fileFilter?(url) ?? true
//                        if includeFile {
//                            $0.append(url)
//                        }
//                        return
//                    }
//                } catch {
//                    logger.warning("Failed to fetch resourceKeys for url: \(url.absoluteString)")
//                }
//            default:
//                return
//            }
        }
        
//        var fileURLs: [URL] = []
//        for case let fileURL as URL in directoryEnumerator {
//            guard let resourceValues = try? fileURL.resourceValues(forKeys: resourceKeys),
//                  let isDirectory = resourceValues.isDirectory,
//                  let name = resourceValues.name
//            else {
//                continue
//            }
//            
//            if isDirectory {
//                if name == "_extras" {
//                    directoryEnumerator.skipDescendants()
//                }
//            } else {
//                fileURLs.append(fileURL)
//            }
//        }
        
        print(fileURLs)

        
        
        
//        guard let directoryEnumerator = FileManager.default.enumerator(
//            at: directoryURL,
//            includingPropertiesForKeys: nil,
//            options: [
//                .skipsHiddenFiles
//                //                .skipsPackageDescendants,
//                //                .skipsSubdirectoryDescendants
//            ]
//        ) else {
//            return []
//        }
//        
//        let urls: [URL] = directoryEnumerator.compactMap {
//            guard let url = $0 as? URL else {
//                return nil
//            }
//            return $0
//        } ?? []
//            .filter {
//                if $0.hasDirectoryPath {
//                    return directoryFilter?($0) ?? true
//                } else {
//                    return fileFilter?($0) ?? true
//                }
//            }
//        
//        let sortedURLs = urls.sorted {
//            let relativePath0 = $0.path(percentEncoded: false).replacingOccurrences(
//                of: directoryURL.path(percentEncoded: false),
//                with: ""
//            )
//            let relativePath1 = $1.path(percentEncoded: false).replacingOccurrences(
//                of: directoryURL.path(percentEncoded: false),
//                with: ""
//            )
//            return relativePath0 < relativePath1
//        }
//        
//        logger.debug("Listing \(urls.count) urls:")
//        
//        sortedURLs.forEach {
//            let relativePath = $0.path(percentEncoded: false).replacingOccurrences(
//                of: directoryURL.path(percentEncoded: false),
//                with: ""
//            )
//            logger.debug("\(relativePath)")
//        }
        
        return []
    }
    
    /// Walks through directory hierarchy of `directoryURL` building a representation of the contents
    /// represented as a `tree` of ``FileCrawler.Item``
    /// - Parameters:
    ///   - directoryURL: The root directory to start walking from
    ///   - isRecursive: Descends into subdirectories to form at tree (if true)
    ///   - directoryFilter: A closure used to include/exclude directories
    ///   - fileFilter: A closure used to include/exclude files
    ///   - level: The recursion level (should only be specified by private callers)
    /// - Returns: <#description#>
    public func walkFileHierarchy(
        directoryURL: URL,
        isRecursive: Bool,
        directoryFilter: ((URL) -> Bool)? = nil,
        fileFilter: ((URL) -> Bool)? = nil,
        level: Int = 0
    ) throws -> [Item] {
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
//                    logger.warning("Exclude fileURL because it failed the fileFilter: \(url.path(percentEncoded: false))")
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
        
        let subdirectoryItems: [Item] = try directoryURLs.enumerated().reduce(
            into: []
        ) { partialResult, iter /*EnumeratedSequence<[Item]>.Iterator.Element*/ in
            let index = iter.offset
            let subdirectoryURL = iter.element
            guard isRecursive else {
                // Done with this dir
                return
            }
            let subdirectoryItems: [Item] = try walkFileHierarchy(
                directoryURL: subdirectoryURL,
                isRecursive: isRecursive,
                directoryFilter: directoryFilter,
                fileFilter: fileFilter,
                level: level + 1
            )
            partialResult.append(contentsOf: subdirectoryItems)
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
            
            let urls = try FileManager.default.contentsOfDirectory(
                at: directoryURL,
                includingPropertiesForKeys: URLResourceKey.allResourceKeys,
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

            //        let sortedByCreateDate = output.sorted { item1, item2 -> Bool in
            //            item1.createDate > item2.createDate
            //        }

            return (directoryURLs: directoryURLs, fileURLs: fileURLs)
        } catch {
            logger.fault("\(error.localizedDescription)")
            throw error
        }
        
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
        
        public var parentDirectoryURL: URL {
            url.deletingLastPathComponent().deletingPathExtension()
        }
        
        public var urlResourcesDescription: String {
            let keys = URLResourceKey.fileKindSystemResourceKeys + URLResourceKey.privacyResourceKeys
            let dict: [String: any CustomStringConvertible] = keys.reduce(into: [:]) {
                $0[$1.rawValue] = url.resourceValue(key: $1) ?? "NOPE!"
            }
            return dict.listDescription(separator: "\n\t")
        }
    }
}

extension [FileCrawler.Item] {
    ///    let urls: [URL] = flattenToURLs(items: items)
    ///    urls.forEach {
    ///        let relativePath = $0.path(percentEncoded: false).replacingOccurrences(
    ///            of: directoryURL.path(percentEncoded: false),
    ///            with: ""
    ///        )
    ///        logger.debug("\(relativePath)")
    ///    }
    ///    let packageURLs: [URL] = []
    ///    return packageURLs
    public func flattenToURLs(
        items: [FileCrawler.Item]
    ) -> [URL] {
        return items.flatMap {
            switch $0 {
            case .directory(let url, _, let directoryItems, let fileItems):
                return [$0.url] + flattenToURLs(items: directoryItems) + flattenToURLs(items: fileItems)
            case .regularFile/*(let url, let sizeInBytes, let isAliasFile, let fileExtension)*/:
                return [$0.url]
            }
        }
    }
}
