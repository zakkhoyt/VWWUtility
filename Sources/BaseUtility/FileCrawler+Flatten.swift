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
        
        func flattenToURLs(
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
        
        let urls: [URL] = flattenToURLs(items: items)
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
