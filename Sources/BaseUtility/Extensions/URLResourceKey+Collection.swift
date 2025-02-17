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

extension URLResourceKey: @retroactive CustomStringConvertible {
    public var description: String {
         switch self {
         case .keysOfUnsetValuesKey: "keysOfUnsetValues"
         case .nameKey: "name"
         case .localizedNameKey: "localizedName"
         case .isRegularFileKey: "isRegularFile"
         case .isDirectoryKey: "isDirectory"
         case .isSymbolicLinkKey: "isSymbolicLink"
         case .isVolumeKey: "isVolume"
         case .isPackageKey: "isPackage"
         case .isApplicationKey: "isApplication"
         case .isSystemImmutableKey: "isSystemImmutable"
         case .isUserImmutableKey: "isUserImmutable"
         case .isHiddenKey: "isHidden"
         case .hasHiddenExtensionKey: "hasHiddenExtension"
         case .creationDateKey: "creationDate"
         case .contentAccessDateKey: "contentAccessDate"
         case .contentModificationDateKey: "contentModificationDate"
         case .attributeModificationDateKey: "attributeModificationDate"
         case .linkCountKey: "linkCount"
         case .parentDirectoryURLKey: "parentDirectoryURL"
         case .volumeURLKey: "volumeURL"
         case .typeIdentifierKey: "typeIdentifier"
         case .contentTypeKey: "contentType"
         case .localizedTypeDescriptionKey: "localizedTypeDescription"
         case .labelNumberKey: "labelNumber"
         case .labelColorKey: "labelColor"
         case .localizedLabelKey: "localizedLabel"
         case .effectiveIconKey: "effectiveIcon"
         case .customIconKey: "customIcon"
         case .fileResourceIdentifierKey: "fileResourceIdentifier"
         case .volumeIdentifierKey: "volumeIdentifier"
         case .preferredIOBlockSizeKey: "preferredIOBlockSize"
         case .isReadableKey: "isReadable"
         case .isWritableKey: "isWritable"
         case .isExecutableKey: "isExecutable"
         case .fileSecurityKey: "fileSecurity"
         case .isExcludedFromBackupKey: "isExcludedFromBackup"
         case .pathKey: "path"
         case .canonicalPathKey: "canonicalPath"
         case .isMountTriggerKey: "isMountTrigger"
         case .generationIdentifierKey: "generationIdentifier"
         case .documentIdentifierKey: "documentIdentifier"
         case .addedToDirectoryDateKey: "addedToDirectoryDate"
         case .fileResourceTypeKey: "fileResourceType"
         case .fileIdentifierKey: "fileIdentifier"
         case .fileContentIdentifierKey: "fileContentIdentifier"
         case .mayShareFileContentKey: "mayShareFileContent"
         case .mayHaveExtendedAttributesKey: "mayHaveExtendedAttributes"
         case .isPurgeableKey: "isPurgeable"
         case .isSparseKey: "isSparse"
         case .thumbnailDictionaryKey: "thumbnailDictionary"
         case .fileSizeKey: "fileSize"
         case .fileAllocatedSizeKey: "fileAllocatedSize"
         case .totalFileSizeKey: "totalFileSize"
         case .totalFileAllocatedSizeKey: "totalFileAllocatedSize"
         case .isAliasFileKey: "isAliasFile"
         case .fileProtectionKey: "fileProtection"
         case .directoryEntryCountKey: "directoryEntryCount"
         case .volumeLocalizedFormatDescriptionKey: "volumeLocalizedFormatDescription"
         case .volumeTotalCapacityKey: "volumeTotalCapacity"
         case .volumeAvailableCapacityKey: "volumeAvailableCapacity"
         case .volumeResourceCountKey: "volumeResourceCount"
         case .volumeSupportsPersistentIDsKey: "volumeSupportsPersistentIDs"
         case .volumeSupportsSymbolicLinksKey: "volumeSupportsSymbolicLinks"
         case .volumeSupportsHardLinksKey: "volumeSupportsHardLinks"
         case .volumeSupportsJournalingKey: "volumeSupportsJournaling"
         case .volumeIsJournalingKey: "volumeIsJournaling"
         case .volumeSupportsSparseFilesKey: "volumeSupportsSparseFiles"
         case .volumeSupportsZeroRunsKey: "volumeSupportsZeroRuns"
         case .volumeSupportsCaseSensitiveNamesKey: "volumeSupportsCaseSensitiveNames"
         case .volumeSupportsCasePreservedNamesKey: "volumeSupportsCasePreservedNames"
         case .volumeSupportsRootDirectoryDatesKey: "volumeSupportsRootDirectoryDates"
         case .volumeSupportsVolumeSizesKey: "volumeSupportsVolumeSizes"
         case .volumeSupportsRenamingKey: "volumeSupportsRenaming"
         case .volumeSupportsAdvisoryFileLockingKey: "volumeSupportsAdvisoryFileLocking"
         case .volumeSupportsExtendedSecurityKey: "volumeSupportsExtendedSecurity"
         case .volumeIsBrowsableKey: "volumeIsBrowsable"
         case .volumeMaximumFileSizeKey: "volumeMaximumFileSize"
         case .volumeIsEjectableKey: "volumeIsEjectable"
         case .volumeIsRemovableKey: "volumeIsRemovable"
         case .volumeIsInternalKey: "volumeIsInternal"
         case .volumeIsAutomountedKey: "volumeIsAutomounted"
         case .volumeIsLocalKey: "volumeIsLocal"
         case .volumeIsReadOnlyKey: "volumeIsReadOnly"
         case .volumeCreationDateKey: "volumeCreationDate"
         case .volumeURLForRemountingKey: "volumeURLForRemounting"
         case .volumeUUIDStringKey: "volumeUUIDString"
         case .volumeNameKey: "volumeName"
         case .volumeLocalizedNameKey: "volumeLocalizedName"
         case .volumeIsEncryptedKey: "volumeIsEncrypted"
         case .volumeIsRootFileSystemKey: "volumeIsRootFileSystem"
         case .volumeSupportsCompressionKey: "volumeSupportsCompression"
         case .volumeSupportsFileCloningKey: "volumeSupportsFileCloning"
         case .volumeSupportsSwapRenamingKey: "volumeSupportsSwapRenaming"
         case .volumeSupportsExclusiveRenamingKey: "volumeSupportsExclusiveRenaming"
         case .volumeSupportsImmutableFilesKey: "volumeSupportsImmutableFiles"
         case .volumeSupportsAccessPermissionsKey: "volumeSupportsAccessPermissions"
         case .volumeSupportsFileProtectionKey: "volumeSupportsFileProtection"
         case .volumeAvailableCapacityForImportantUsageKey: "volumeAvailableCapacityForImportantUsage"
         case .volumeAvailableCapacityForOpportunisticUsageKey: "volumeAvailableCapacityForOpportunisticUsage"
         case .volumeTypeNameKey: "volumeTypeName"
         case .volumeSubtypeKey: "volumeSubtype"
         case .volumeMountFromLocationKey: "volumeMountFromLocation"
         case .isUbiquitousItemKey: "isUbiquitousItem"
         case .ubiquitousItemHasUnresolvedConflictsKey: "ubiquitousItemHasUnresolvedConflicts"
         case .ubiquitousItemIsDownloadingKey: "ubiquitousItemIsDownloading"
         case .ubiquitousItemIsUploadedKey: "ubiquitousItemIsUploaded"
         case .ubiquitousItemIsUploadingKey: "ubiquitousItemIsUploading"
         case .ubiquitousItemDownloadingStatusKey: "ubiquitousItemDownloadingStatus"
         case .ubiquitousItemDownloadingErrorKey: "ubiquitousItemDownloadingError"
         case .ubiquitousItemUploadingErrorKey: "ubiquitousItemUploadingError"
         case .ubiquitousItemDownloadRequestedKey: "ubiquitousItemDownloadRequested"
         case .ubiquitousItemContainerDisplayNameKey: "ubiquitousItemContainerDisplayName"
         case .ubiquitousItemIsExcludedFromSyncKey: "ubiquitousItemIsExcludedFromSync"
         case .ubiquitousItemIsSharedKey: "ubiquitousItemIsShared"
         case .ubiquitousSharedItemCurrentUserRoleKey: "ubiquitousSharedItemCurrentUserRole"
         case .ubiquitousSharedItemCurrentUserPermissionsKey: "ubiquitousSharedItemCurrentUserPermissions"
         case .ubiquitousSharedItemOwnerNameComponentsKey: "ubiquitousSharedItemOwnerNameComponents"
         case .ubiquitousSharedItemMostRecentEditorNameComponentsKey: "ubiquitousSharedItemMostRecentEditorNameComponents"
         default: "unknown"
         }
    }
}

extension URLResourceKey: @retroactive CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(description) (\(rawValue))"
    }
    
}
