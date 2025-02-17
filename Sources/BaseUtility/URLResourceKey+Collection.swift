import Foundation

extension URLResourceKey {
    
#warning("FIXME: zakkhoyt - remove these arrays")
    public static let fileKindSystemResourceKeys: [URLResourceKey] = [
        .isDirectoryKey,
        .isRegularFileKey
    ]
    
    public static let directoryResourceKeys: [URLResourceKey] = [
        .isSymbolicLinkKey
    ]
    
    public static let regularFileResourceKeys: [URLResourceKey] = [
        .isAliasFileKey,
        .fileSizeKey // bytes
    ]
    
    public static let commonRequiredResourceKeys: [URLResourceKey] = [
        .pathKey,
        .canonicalPathKey,
        .addedToDirectoryDateKey,
        .contentModificationDateKey,
        .creationDateKey,
    ]
    
    public static let privacyResourceKeys: [URLResourceKey] = [
        .isExcludedFromBackupKey,
        .isHiddenKey
    ]
    
    public static let otherResourceKeys: [URLResourceKey] = [
        .isPurgeableKey,
        .fileProtectionKey,
        .fileSecurityKey,
        .isPackageKey,
        .ubiquitousItemIsExcludedFromSyncKey,
    ]
    
    public static let directoryRsourceKeys: [URLResourceKey] = [
        commonRequiredResourceKeys,
        privacyResourceKeys,
        otherResourceKeys,
        directoryResourceKeys
    ].flatMap {
        $0
    }
    
    public static let fileResourceKeys: [URLResourceKey] =  [
        commonRequiredResourceKeys,
        privacyResourceKeys,
        otherResourceKeys,
        fileKindSystemResourceKeys
    ].flatMap {
        $0
    }
    
    
    public static let allResourceKeys: [URLResourceKey] = [
        commonRequiredResourceKeys,
        privacyResourceKeys,
        otherResourceKeys,
        directoryResourceKeys
    ].flatMap {
        $0
    }
}
    
extension Set<URLResourceKey> {
    public static let fileKindSystemResourceKeys = Set<URLResourceKey>(URLResourceKey.fileKindSystemResourceKeys)
    public static let directoryResourceKeys = Set<URLResourceKey>(URLResourceKey.directoryResourceKeys)
    public static let regularFileResourceKeys = Set<URLResourceKey>(URLResourceKey.regularFileResourceKeys)
    public static let commonRequiredResourceKeys = Set<URLResourceKey>(URLResourceKey.commonRequiredResourceKeys)
    public static let privacyResourceKeys = Set<URLResourceKey>(URLResourceKey.privacyResourceKeys)
    public static let otherResourceKeys = Set<URLResourceKey>(URLResourceKey.otherResourceKeys)
    public static let directoryRsourceKeys = Set<URLResourceKey>(URLResourceKey.directoryRsourceKeys)
    public static let fileResourceKeys = Set<URLResourceKey>(URLResourceKey.fileResourceKeys)
    public static let allResourceKeys = Set<URLResourceKey>(URLResourceKey.allResourceKeys)
}
