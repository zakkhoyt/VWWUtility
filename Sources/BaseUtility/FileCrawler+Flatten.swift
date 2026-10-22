import BaseUtility
import Foundation

public struct PackageToJsonConverter {

#warning("TODO: zakkhoyt - ")

    
#warning("""
FIXME: zakkhoyt - Implement in VWWUtility. 
This works for finding Package.swift when dir by subdir evaluation is important. 
* Gives dir/file hierarchy
* is slower to search 
* Currenlty dives in to hidden directories (perhaps a dir filter closure too?)
""")
    public static func findSwiftPackages(
        directoryURL: URL
    ) throws -> [URL] {
        let items = try FileCrawler().walkFileHierarchy(
            directoryURL: directoryURL,
            isRecursive: true,
            fileFilter: { fileURL in
                fileURL.lastPathComponent == "Package.swift"
            }
        )
        
        let urls: [URL] = FileCrawler.Item.flattenToURLs(items: items)
        urls.forEach {
            let relativePath = $0.path(percentEncoded: false).replacingOccurrences(
                of: directoryURL.path(percentEncoded: false),
                with: ""
            )
            logger.debug("\(relativePath)")
        }
        let packageURLs: [URL] = []
        return packageURLs
    }
}

extension FileCrawler.Item {
    /// From tree to flat array (`url` property will still give correct paths
    public static func flatten(
        items: [FileCrawler.Item]
    ) -> [FileCrawler.Item] {
        items.flatMap {
            switch $0 {
            case .directory(_, _, let directoryItems, let fileItems):
                return [$0] + flatten(items: directoryItems) + flatten(items: fileItems)
            case .regularFile/*(let url, let sizeInBytes, let isAliasFile, let fileExtension)*/:
                return [$0]
            }
        }
    }

    /// From tree to flat array (`url` property will still give correct paths
    public static func flattenToURLs(
        items: [FileCrawler.Item]
    ) -> [URL] {
        flatten(items: items).map { $0.url }
    }
}

