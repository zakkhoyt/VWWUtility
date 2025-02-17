//
// URLService.swift
// BaseUtility
//
// Created by Zakk Hoyt 2023
// Copyright © 2023 Zakk Hoyt. All rights reserved.
//

import Foundation

//
//extension URL {
//    /// ## Example:
//    /// ```
//    /// file:///private/var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/38740A09-F9F8-52C9-889F-108270F850FA/d/Wrapper/WalkingSkeletonApp.app/
//    /// ```
//    public var d_fileurl: String {
//        absoluteString
//    }
//    
//    /// ## Example:
//    /// ```
//    /// /private/var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/38740A09-F9F8-52C9-889F-108270F850FA/d/Wrapper/WalkingSkeletonApp.app/`
//    /// ```
//    public var d_filepath: String {
//        absoluteURL.path(percentEncoded: false)
//    }
//    
//}
//



/// Running
/// ## Bundle.main
///
/// ## Bundle.module
///
/// ## BundleallBundles
/// * Found `47` of them for `FileVault.app`
///
/// ## BundleallFrameworks
/// * Found `636` of them for `FileVault.app`
///
/// # URL
/// ## Designed for iPhone/iPad
/// ```sh
/// bundleURL -> "file:///System/iOSSupport/System/Library/AccessibilityBundles/SwiftUI.axbundle"
/// resourceURL -> "$BUNDLE_BUNDLE_PATH/Contents/Resources"
/// executableURL -> "$BUNDLE_BUNDLE_PATH/Contents/MacOS/SwiftUI"
/// privateFrameworksURL -> "$BUNDLE_BUNDLE_PATH/Contents/Frameworks"
/// sharedFrameworksURL -> "$BUNDLE_BUNDLE_PATH/Contents/SharedFrameworks"
/// sharedSupportURL -> "$BUNDLE_BUNDLE_PATH/Contents/SharedSupport"
/// builtInPlugInsURL -> "$BUNDLE_BUNDLE_PATH/Contents/PlugIns"
/// appStoreReceiptURL ->
/// ```
extension Bundle {
    public var debugSummary: String {
        """
          description: \(description)
          bundleIdentifier: \(bundleIdentifier ?? "<nil>")
          bundleURL \(bundleURL.absoluteString)
          resourceURL? \(resourceURL?.absoluteString ?? "<nil>")
          executableURL? \(executableURL?.absoluteString ?? "<nil>")
          privateFrameworksURL? \(privateFrameworksURL?.absoluteString ?? "<nil>")
          sharedFrameworksURL? \(sharedFrameworksURL?.absoluteString ?? "<nil>")
          sharedSupportURL? \(sharedSupportURL?.absoluteString ?? "<nil>")
          builtInPlugInsURL? \(builtInPlugInsURL?.absoluteString ?? "<nil>")
          appStoreReceiptURL? \(appStoreReceiptURL?.absoluteString ?? "<nil>")
        """
    }
    
    
    public static var allBundlesDebugSummary: String {
        //        class var allBundles: [Bundle]
        //        class var allFrameworks: [Bundle]
        
        
        let allBundles = Bundle.allBundles.enumerated().map {
            [
                "Bundle.allBundles[\($0.offset)]:\n\($0.element.debugSummary)"
            ].joined(separator: "\n")
        }
        
        let allFrameworks = Bundle.allFrameworks.enumerated().map {
            [
                "Bundle.allFrameworks[\($0.offset)]:\n\($0.element.debugSummary)"
            ].joined(separator: "\n")
        }
        
        
        return """
        Bundle.main:\n\(Bundle.main.debugSummary)
        
        Bundle.module:\n\(Bundle.module.debugSummary)
        
        Bundle.allBundles:\n\(allBundles)
        
        Bundle.allFrameworks:\n\(allFrameworks)
        
        """
        
        //        Bundle.module: \()
        
        
        
    }
}




/// Provides convenience functions for processing `URL`s, reading files, etc...
///
/// * Dir `URL`s such as `Library`, `Documents`, etc..
/// * File `URL`s such as `*.log`, `*.plist`, etc...
///
/// Read about the **application sandbox** and **shared app groups** in the article:  <doc:FilesOnIOS>
public enum URLService {
    //    /// Returns a `URL` pointing to the shared app group directory.
    //    /// - Remark: Return value will vary depending on the current build configuration.
    //    ///
    //    /// ## SeeAlso
    //    ///
    //    /// `AppGroupIdentifier.myApp.appGroupIdentifier`
    //    ///
    //    public static var appGroupDirUrl: URL = {
    //        guard let url = FileManager.default.containerURL(
    //            forSecurityApplicationGroupIdentifier: AppGroupIdentifier.myApp.appGroupIdentifier
    //        ) else {
    //            preconditionFailure("Failed to get URL for app group \(AppGroupIdentifier.mhApp.appGroupIdentifier)")
    //        }
    //        return url
    //    }()


#warning("TODO: zakkhoyt - move to Bundle extension")
    public static let bundleModuleURL: URL = Bundle.module.bundleURL
    
    
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
//    adminApplicationDirectory // System and network administration applications.
//    allApplicationsDirectory // All directories where applications can be stored.
//    allLibrariesDirectory // All directories where resources can be stored.
//    applicationDirectory // Supported applications (/Applications).
//    applicationScriptsDirectory // The user scripts folder for the calling application (~/Library/Application Scripts/<code-signing-id>.
//    applicationSupportDirectory // Application support files (Library/Application Support).
//    autosavedInformationDirectory // The user’s autosaved documents (Library/Autosave Information).
//    cachesDirectory // Discardable cache files (Library/Caches).
//    coreServiceDirectory // Core services (System/Library/CoreServices).
//    demoApplicationDirectory // Unsupported applications and demonstration versions.
//    desktopDirectory // The user’s desktop directory.
//    developerApplicationDirectory // Developer applications (/Developer/Applications).
//    developerDirectory // Developer resources (/Developer).
//    documentationDirectory // Documentation.
//    documentDirectory // Document directory.
//    downloadsDirectory // The user’s downloads directory.
//    inputMethodsDirectory // Input Methods (Library/Input Methods).
//    itemReplacementDirectory // The constant used to create a temporary directory.
//    libraryDirectory // Various user-visible documentation, support, and configuration files (/Library).
//    moviesDirectory // The user’s Movies directory (~/Movies).
//    musicDirectory // The user’s Music directory (~/Music).
//    picturesDirectory // The user’s Pictures directory (~/Pictures).
//    preferencePanesDirectory // The PreferencePanes directory for use with System Preferences (Library/PreferencePanes).
//    printerDescriptionDirectory // The system’s PPDs directory (Library/Printers/PPDs).
//    sharedPublicDirectory // The user’s Public sharing directory (~/Public).
//    trashDirectory // The trash directory.
//    userDirectory // User home directories (/Users).

    
    
    
    
    
    
    // MARK: Public static vars
    
    /// Returns the directory of the application sandbox.
    ///
    /// ## iPhone/iPad (Simulator)
    /// ```swift
    /// $HOME/Library/Developer/CoreSimulator/Devices/${IOS_SIM_UUID}/data/Containers/Data/Application/${BUNDLE_MAIN_BUNDLEIDENTIFIER}/
    /// ```
    ///
    /// ## iPhone/iPad (Real Device)
    /// ```swift
    /// /private/var/mobile/Containers/Data/Application/${BUNDLE_MAIN_BUNDLEIDENTIFIER}/
    /// ```
    ///
    /// ## Designed for iPhone/iPad (Running as MacOS App)
    /// ```sh
    /// $HOME/Library/Containers/${BUNDLE_MAIN_BUNDLEIDENTIFIER}/Data/
    /// ```
    ///
    /// Which has these directories by default
    /// ```sh
    /// Desktop -> ../../../../Desktop       # URLService.desktopDirURL
    /// Documents                            # URLService.documentsDirURL
    /// Downloads -> ../../../../Downloads   # URLService.downloadsDirURL
    /// Library                              # URLService.libraryDirURL
    /// Movies -> ../../../../Movies         #
    /// Music -> ../../../../Music           #
    /// Pictures -> ../../../../Pictures     #
    /// SystemData                           #
    /// tmp                                  # URLService.documentsDirURL
    /// ```
    ///
    /// ## Catalyst (Running as MacOS App)
    /// ```sh
    /// TODO: zakkhoyt - implement and documetn
    /// ```
    ///
    /// ## MacOS App
    /// ```sh
    /// TODO: zakkhoyt - implement and documetn
    /// ```
    ///
    public static let applicationDirURL: URL = documentsDirURL.deletingLastPathComponent()

    /// Returns the `Documents` directory in the application sandbox.
    ///
    /// ## iPhone/iPad
    /// ```sh
    /// /private/var/mobile/Containers/Data/Application/\(uuidString)/Documents/
    /// ```
    ///
    /// ## Designed for iPhone/iPad
    /// ```sh
    /// $HOME/Library/Containers/$APP_UUID/Data/Documents/
    /// ```
    public static let documentsDirURL: URL = {
        guard let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first else {
            preconditionFailure("Failed to get path for .documentDirectory")
        }
        return URL(fileURLWithPath: path).preferCanonicalURL
    }()

    
    /// Returns the `Library` directory in the application sandbox.
    ///
    /// ## iPhone/iPad
    /// ```sh
    /// /private/var/mobile/Containers/Data/Application/\(uuidString)/Library/
    /// ```

    public static let libraryDirURL: URL = {
        guard let path = NSSearchPathForDirectoriesInDomains(
            .libraryDirectory, .userDomainMask, true
        ).first else {
            preconditionFailure("Failed to get path for .libraryDirectory")
        }
        return URL(fileURLWithPath: path).preferCanonicalURL
    }()
    
    /// Returns the `Library/Preferences` directory in the application sandbox.
    public static let preferencesDirUrl = libraryDirURL.appendingPathComponent("Preferences")
    
    /// Returns a `URL` pointing to the backing `plist` file for `UserDefaults.standard`.
    public static let standardUserDefaultsUrl: URL = {
        guard let mainBundleIdentifier = Bundle.main.bundleIdentifier else {
            preconditionFailure("Bundle.main.bundleIdentifier == nil")
        }
        return preferencesDirUrl
            .appendingPathComponent(mainBundleIdentifier)
            .appendingPathExtension("plist")
            .preferCanonicalURL
    }()
    
    /// Returns a `URL` pointing to the backing `plist` file for `UserDefaults(suiteName:)`.
    public static func suiteUserDefaultsUrl(suiteName: String) -> URL {
        preferencesDirUrl
            .appendingPathComponent(suiteName)
            .appendingPathExtension("plist")
            .preferCanonicalURL
    }
    
    
    
    // MARK: Public static funcs
    
    // TODO: zakkhoyt - Move to FileService? Bundle?
    public static func dictionary(plistUrl url: URL) -> [String: Any] {
        guard let nsDict = NSDictionary(contentsOf: url) else { return [:] }
        guard let dict = nsDict as? [String: Any] else { return [:] }
        return dict
    }
    
    public static func plistKeys(from url: URL) -> [String] {
        guard let dict = NSDictionary(contentsOf: url) else { return [] }
        guard let allKeys = dict.allKeys as? [String] else { return [] }
        return allKeys
    }
}

