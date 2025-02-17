//
//  AppTargetService.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 2/17/25.
//

//#if os(iOS)
//import UIKit
//#elseif os(macOS)
//import AppKit
//#endif

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

public struct PlatformService {
    
    // * [ ] iOSDevice
    // * [ ] iOSSimulator
    // * [ ] macDesignedForIPhoneIPad
    // * [ ] macCatalyst
    // * [ ] macNative
    public static func logPlatformVariants() {

        
#if os(macOS)
        logger.debug("#if os(macOS): true")
#else
        logger.debug("#if os(macOS): false")
#endif
        
#if canImport(AppKit)
        logger.debug("#if canImport(AppKit): true")
#else
        logger.debug("#if canImport(AppKit): false")
#endif
        

#if os(iOS)
        logger.debug("#if os(iOS): true")
#else
        logger.debug("#if os(iOS): false")
#endif
        
#if canImport(UIKit)
        logger.debug("#if canImport(UIKit): true")
#else
        logger.debug("#if canImport(UIKit): false")
#endif
                
#if targetEnvironment(simulator)
        logger.debug("#if targetEnvironment(simulator): \(true)")
#else
        logger.debug("#if targetEnvironment(simulator): \(false)")
#endif

#if targetEnvironment(macCatalyst)
        logger.debug("#if targetEnvironment(macCatalyst): \(true)")
#else
        logger.debug("#if targetEnvironment(macCatalyst): \(false)")
#endif
        
        logger.debug("ProcessInfo.processInfo.isiOSAppOnMac: \(ProcessInfo.processInfo.isiOSAppOnMac)")        
        logger.debug("ProcessInfo.processInfo.isMacCatalystApp: \(ProcessInfo.processInfo.isMacCatalystApp)")
        logger.debug("")
        
        // Some of these (hostname) do prompt the user for permission:
        //
        // "Allow "CameraPreviewUl" to find devices on local networks?"
        // "This will allow the app to discover, connect to, and collect data from
        // devices on your networks."
        
        logger.debug("ProcessInfo.processInfo.hostName: \(ProcessInfo.processInfo.hostName)") // String
        logger.debug("ProcessInfo.processInfo.processName: \(ProcessInfo.processInfo.processName)") // String
        logger.debug("ProcessInfo.processInfo.processIdentifier: \(ProcessInfo.processInfo.processIdentifier)") // Int32
        logger.debug("ProcessInfo.processInfo.globallyUniqueString: \(ProcessInfo.processInfo.globallyUniqueString)") // String
        logger.debug("ProcessInfo.processInfo.processorCount: \(ProcessInfo.processInfo.processorCount)") // Int
        logger.debug("ProcessInfo.processInfo.activeProcessorCount: \(ProcessInfo.processInfo.activeProcessorCount)") // Int
        logger.debug("ProcessInfo.processInfo.physicalMemory: \(ProcessInfo.processInfo.physicalMemory)") // UInt64
        logger.debug("ProcessInfo.processInfo.systemUptime: \(ProcessInfo.processInfo.systemUptime)") // TimeInterval
        logger.debug("ProcessInfo.processInfo.operatingSystem(): \(ProcessInfo.processInfo.operatingSystem())") // Int
        logger.debug("ProcessInfo.processInfo.operatingSystemName(): \(ProcessInfo.processInfo.operatingSystemName())") // String
        logger.debug("ProcessInfo.processInfo.operatingSystemVersionString: \(ProcessInfo.processInfo.operatingSystemVersionString)") // String
        logger.debug("ProcessInfo.processInfo.operatingSystemVersion: \(ProcessInfo.processInfo.operatingSystemVersion)") // OperatingSystemVersion
        logger.debug("ProcessInfo.processInfo.thermalState: \(ProcessInfo.processInfo.thermalState)") // ProcessInfo.ThermalState
        logger.debug("ProcessInfo.processInfo.isLowPowerModeEnabled: \(ProcessInfo.processInfo.isLowPowerModeEnabled)") // Bool
        logger.debug("")
        
        logger.debug("URLService.applicationDirURL.path: \(URLService.applicationDirURL.path)")
        logger.debug("URLService.applicationDirectoryURL.path: \(URLService.applicationDirectoryURL.path)")
        logger.debug("URLService.appGroupDirURL(appGroupIdentifier: \"group.co.z2k.test\").path: \(URLService.appGroupDirURL(appGroupIdentifier: "group.co.z2k.test")?.path ?? "<nil>")")
        logger.debug("")
        logger.debug("PlatformService.DirectorySearchPath.debugSummary for .userDomainMask:\n\(PlatformService.DirectorySearchPath.debugSummary)")
        logger.debug("")
        
//        logger.debug("Bundle.main.bundlePath: \(Bundle.main.bundlePath)")
        logger.debug("Bundle.main.debugSummary:\n\(Bundle.main.debugSummary)")
        
        
        
//        logger.debug("Bundle.module.bundlePath: \(Bundle.module.bundlePath)")
        logger.debug("Bundle.module.debugSummary:\n\(Bundle.module.debugSummary)")
        logger.debug("")
    }
}


extension PlatformService {
    
#warning(
    """
    TODO: zakkhoyt - Make an enum to supoort and logs these
    Document for each
    * iPhone/iPad
    * iOS Sim
    * Designed for iPhone/iPad
    * Catalyst
    * macOS
    """
)
    
    

    
    /// Wrapper around  `FileManager.SearchPathDirectory`
    
    public enum DirectorySearchPath: UInt, @unchecked Sendable, CaseIterable, CustomStringConvertible, CustomDebugStringConvertible {
        case adminApplicationDirectory // System and network administration applications.
        case allApplicationsDirectory // All directories where applications can be stored.
        case allLibrariesDirectory // All directories where resources can be stored.
        case applicationDirectory // Supported applications (/Applications).
        case applicationSupportDirectory // Application support files (Library/Application Support).
        case cachesDirectory // Discardable cache files (Library/Caches).
        case coreServiceDirectory // Core services (System/Library/CoreServices).
        case demoApplicationDirectory // Unsupported applications and demonstration versions.
        case desktopDirectory // The user’s desktop directory.
        case developerApplicationDirectory // Developer applications (/Developer/Applications).
        case developerDirectory // Developer resources (/Developer).
        case documentationDirectory // Documentation.
        case documentDirectory // Document directory.
        case libraryDirectory // Various user-visible documentation, support, and configuration files (/Library).
        case userDirectory // User home directories (/Users).
        
#if os(macOS)
        case applicationScriptsDirectory // The user scripts folder for the calling application (~/Library/Application Scripts/<code-signing-id>.
        case autosavedInformationDirectory // The user’s autosaved documents (Library/Autosave Information).
        case downloadsDirectory // The user’s downloads directory.
        case inputMethodsDirectory // Input Methods (Library/Input Methods).
        case itemReplacementDirectory // The constant used to create a temporary directory.
        case moviesDirectory // The user’s Movies directory (~/Movies).
        case musicDirectory // The user’s Music directory (~/Music).
        case picturesDirectory // The user’s Pictures directory (~/Pictures).
        case preferencePanesDirectory // The PreferencePanes directory for use with System Preferences (Library/PreferencePanes).
        case printerDescriptionDirectory // The system’s PPDs directory (Library/Printers/PPDs).
        case sharedPublicDirectory // The user’s Public sharing directory (~/Public).
        case trashDirectory // The trash directory.
#endif
        
        static var debugSummary: String {
            Self.allCases.enumerated()
                .map {
                    let (index, dirSearchPath) = $0
                    let urls = dirSearchPath.urls(domainMask: .userDomainMask)
                    let pathsSummary: String = {
                        if urls.isEmpty {
                            return "<nil>"
                        } else if urls.count == 1 {
                            return urls.map { $0.path }.joined()
                        } else if urls.count > 1 {
                            let separator = "\n        "
                            return separator + urls.map { $0.path }.joined(separator: separator)
                        } else {
                            return ""
                        }
                    }()
                    
                    return "    [\(index)] .\(dirSearchPath.description): \(pathsSummary)"
                }
                .joined(separator: "\n")
        }
        
        /// Converts to `FileManager.SearchPathDirectory`
        private var searchPathDirectory: FileManager.SearchPathDirectory {
            switch self {
            case .adminApplicationDirectory: .adminApplicationDirectory
            case .allApplicationsDirectory: .allApplicationsDirectory
            case .allLibrariesDirectory: .allLibrariesDirectory
            case .applicationDirectory: .applicationDirectory
            case .applicationSupportDirectory: .applicationSupportDirectory
            case .cachesDirectory: .cachesDirectory
            case .coreServiceDirectory: .coreServiceDirectory
            case .demoApplicationDirectory: .demoApplicationDirectory
            case .desktopDirectory: .desktopDirectory
            case .developerApplicationDirectory: .developerApplicationDirectory
            case .developerDirectory: .developerDirectory
            case .documentationDirectory: .documentationDirectory
            case .documentDirectory: .documentDirectory
            case .libraryDirectory: .libraryDirectory
            case .userDirectory: .userDirectory
                
#if os(macOS)
            case .applicationScriptsDirectory: .applicationScriptsDirectory
            case .autosavedInformationDirectory: .autosavedInformationDirectory
            case .downloadsDirectory: .downloadsDirectory
            case .inputMethodsDirectory: .inputMethodsDirectory
            case .itemReplacementDirectory: .itemReplacementDirectory
            case .moviesDirectory: .moviesDirectory
            case .musicDirectory: .musicDirectory
            case .picturesDirectory: .picturesDirectory
            case .preferencePanesDirectory: .preferencePanesDirectory
            case .printerDescriptionDirectory: .printerDescriptionDirectory
            case .sharedPublicDirectory: .sharedPublicDirectory
            case .trashDirectory: .trashDirectory
#endif
            }
        }
        
        public var summary: String {
            switch self {
            case .adminApplicationDirectory: "System and network administration applications"
            case .allApplicationsDirectory: "All directories where applications can be stored"
            case .allLibrariesDirectory: "All directories where resources can be stored"
            case .applicationDirectory: "Supported applications (/Applications)"
            case .applicationSupportDirectory: "Application support files (Library/Application Support)"
            case .cachesDirectory: "Discardable cache files (Library/Caches)"
            case .coreServiceDirectory: "Core services (System/Library/CoreServices)"
            case .demoApplicationDirectory: "Unsupported applications and demonstration versions"
            case .desktopDirectory: "The user’s desktop directory"
            case .developerApplicationDirectory: "Developer applications (/Developer/Applications)"
            case .developerDirectory: "Developer resources (/Developer)"
            case .documentationDirectory: "Documentation"
            case .documentDirectory: "Document directory"
            case .libraryDirectory: "Various user-visible documentation, support, and configuration files (/Library)"
            case .userDirectory: "User home directories (/Users)"
                
#if os(macOS)
            case .applicationScriptsDirectory: "The user scripts folder for the calling application (~/Library/Application Scripts/<code-signing-id>"
            case .autosavedInformationDirectory: "The user’s autosaved documents (Library/Autosave Information)"
            case .downloadsDirectory: "The user’s downloads directory"
            case .inputMethodsDirectory: "Input Methods (Library/Input Methods)"
            case .itemReplacementDirectory: "The constant used to create a temporary directory"
            case .moviesDirectory: "The user’s Movies directory (~/Movies)"
            case .musicDirectory: "The user’s Music directory (~/Music)"
            case .picturesDirectory: "The user’s Pictures directory (~/Pictures)"
            case .preferencePanesDirectory: "The PreferencePanes directory for use with System Preferences (Library/PreferencePanes)"
            case .printerDescriptionDirectory: "The system’s PPDs directory (Library/Printers/PPDs)"
            case .sharedPublicDirectory: "The user’s Public sharing directory (~/Public)"
            case .trashDirectory: "The trash directory"
#endif
            }
        }
        
        public func urls(
            domainMask: FileManager.SearchPathDomainMask = .userDomainMask
        ) -> [URL] {
            let paths = NSSearchPathForDirectoriesInDomains(
                self.searchPathDirectory,
                .userDomainMask,
                true
            )
            if paths.count > 1 {
                logger.debug("Found \(paths.count) paths for directorySearchPath: \(self) and domain: \(domainMask)")
            }
            guard !paths.isEmpty else {
                return []
            }
            return paths.map {
                URL(fileURLWithPath: $0).preferCanonicalURL
            }
            
        }
        
        public var description: String {
            switch self {
            case .adminApplicationDirectory: "adminApplicationDirectory"
            case .allApplicationsDirectory: "allApplicationsDirectory"
            case .allLibrariesDirectory: "allLibrariesDirectory"
            case .applicationDirectory: "applicationDirectory"
            case .applicationSupportDirectory: "applicationSupportDirectory"
            case .cachesDirectory: "cachesDirectory"
            case .coreServiceDirectory: "coreServiceDirectory"
            case .demoApplicationDirectory: "demoApplicationDirectory"
            case .desktopDirectory: "desktopDirectory"
            case .developerApplicationDirectory: "developerApplicationDirectory"
            case .developerDirectory: "developerDirectory"
            case .documentationDirectory: "documentationDirectory"
            case .documentDirectory: "documentDirectory"
            case .libraryDirectory: "libraryDirectory"
            case .userDirectory: "userDirectory"
                
#if os(macOS)
            case .applicationScriptsDirectory: "applicationScriptsDirectory"
            case .autosavedInformationDirectory: "autosavedInformationDirectory"
            case .downloadsDirectory: "downloadsDirectory"
            case .inputMethodsDirectory: "inputMethodsDirectory"
            case .itemReplacementDirectory: "itemReplacementDirectory"
            case .moviesDirectory: "moviesDirectory"
            case .musicDirectory: "musicDirectory"
            case .picturesDirectory: "picturesDirectory"
            case .preferencePanesDirectory: "preferencePanesDirectory"
            case .printerDescriptionDirectory: "printerDescriptionDirectory"
            case .sharedPublicDirectory: "sharedPublicDirectory"
            case .trashDirectory: "trashDirectory"
#endif
            }
        }
        
        
        public var debugDescription: String {
            switch self {
            case .adminApplicationDirectory: "System and network administration applications"
            case .allApplicationsDirectory: "All directories where applications can be stored"
            case .allLibrariesDirectory: "All directories where resources can be stored"
            case .applicationDirectory: "Supported applications (/Applications)"
            case .applicationSupportDirectory: "Application support files (Library/Application Support)"
            case .cachesDirectory: "Discardable cache files (Library/Caches)"
            case .coreServiceDirectory: "Core services (System/Library/CoreServices)"
            case .demoApplicationDirectory: "Unsupported applications and demonstration versions"
            case .desktopDirectory: "The user’s desktop directory"
            case .developerApplicationDirectory: "Developer applications (/Developer/Applications)"
            case .developerDirectory: "Developer resources (/Developer)"
            case .documentationDirectory: "Documentation"
            case .documentDirectory: "Document directory"
            case .libraryDirectory: "Various user-visible documentation, support, and configuration files (/Library)"
            case .userDirectory: "User home directories (/Users)"
                
#if os(macOS)
            case .applicationScriptsDirectory: "The user scripts folder for the calling application (~/Library/Application Scripts/<code-signing-id>"
            case .autosavedInformationDirectory: "The user’s autosaved documents (Library/Autosave Information)"
            case .downloadsDirectory: "The user’s downloads directory"
            case .inputMethodsDirectory: "Input Methods (Library/Input Methods)"
            case .itemReplacementDirectory: "The constant used to create a temporary directory"
            case .moviesDirectory: "The user’s Movies directory (~/Movies)"
            case .musicDirectory: "The user’s Music directory (~/Music)"
            case .picturesDirectory: "The user’s Pictures directory (~/Pictures)"
            case .preferencePanesDirectory: "The PreferencePanes directory for use with System Preferences (Library/PreferencePanes)"
            case .printerDescriptionDirectory: "The system’s PPDs directory (Library/Printers/PPDs)"
            case .sharedPublicDirectory: "The user’s Public sharing directory (~/Public)"
            case .trashDirectory: "The trash directory"
#endif
            }
        }
    }
    
#warning(
    """
    TODO: zakkhoyt - These too under Foundation.NSPathUtilities
    public func NSUserName() -> String
    public func NSFullUserName() -> String
    public func NSHomeDirectory() -> String
    public func NSHomeDirectoryForUser(_ userName: String?) -> String?
    public func NSTemporaryDirectory() -> String
    public func NSOpenStepRootDirectory() -> String
    """
    )

}

extension PlatformService {
    public enum Platform: String {
        case iOSDevice
        case iOSSimulator
        case macDesignedForIPhoneIPad
        case macCatalyst
        case macNative
        
    }
}

extension PlatformService.Platform: CustomStringConvertible {
    public var description: String {
        switch self {
        case .iOSDevice: "An iOS app running on a physical iOS device"
        case .iOSSimulator: "An iOS app running on an iOS Simulator on macOS"
        case .macDesignedForIPhoneIPad: "An iOS app running in a window on macOS (comiled to run on iOS. No separate compile needed)"
        case .macCatalyst: "An iOS app running in a window on macOS (but recompiled to run on macOS)"
        case .macNative: "A macOS app running on macOS."
        }
    }
}

extension PlatformService.Platform: CustomDebugStringConvertible {
    public var debugDescription: String {
        switch self {
        case .iOSDevice: "iPhone/iPad Device"
        case .iOSSimulator: "iOS Simulator"
        case .macDesignedForIPhoneIPad: "iPhone/iPad Device"
        case .macCatalyst: "iOS Simulator"
        case .macNative: "iPhone/iPad Device"
        }
    }
}

extension OperatingSystemVersion: @retroactive CustomStringConvertible {
    public var description: String {
        "\(majorVersion).\(minorVersion).\(patchVersion)"
    }
    
}

extension ProcessInfo.ThermalState: @retroactive CustomStringConvertible {
    public var description: String {
        switch self {
        case .nominal: "nominal"
        case .fair: "fair"
        case .serious: "serious"
        case .critical: "critical"
        @unknown default: "unhandled"
        }
    }
}

extension ProcessInfo.ThermalState: @retroactive CustomDebugStringConvertible {
    public var debugDescription: String {
        "\(description) (\(rawValue))"
    }
}


//public struct SearchPathDomainMask : OptionSet, @unchecked Sendable {
extension FileManager.SearchPathDomainMask: CustomStringConvertible {
    var allCases: [FileManager.SearchPathDomainMask] {
        [
            .userDomainMask,
            .localDomainMask,
            .networkDomainMask,
            .systemDomainMask,
            .allDomainsMask
        ]
    }
    
    public var description: String {
//        let masks: [FileManager.SearchPathDomainMask] =
        allCases.reduce(
            into: [FileManager.SearchPathDomainMask]()
        ) { //partialResult, FileManager.SearchPathDomainMask in
            if self.contains($1) {
                $0.append($1)
            }
        }.map {
            switch $0 {
            case .userDomainMask: "userDomainMask"
            case .localDomainMask: "localDomainMask"
            case .networkDomainMask: "networkDomainMask"
            case .systemDomainMask: "systemDomainMask"
            case .allDomainsMask: "allDomainsMask"
            default: "unknown"
            }
        }.joined(separator: ", ")
    }
//    public init(rawValue: UInt)
//    
//    public static var userDomainMask: FileManager.SearchPathDomainMask { get }
//    
//    public static var localDomainMask: FileManager.SearchPathDomainMask { get }
//    
//    public static var networkDomainMask: FileManager.SearchPathDomainMask { get }
//    
//    public static var systemDomainMask: FileManager.SearchPathDomainMask { get }
//    
//    public static var allDomainsMask: FileManager.SearchPathDomainMask { get }
}
