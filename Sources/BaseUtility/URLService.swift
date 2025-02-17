//
// URLService.swift
// BaseUtility
//
// Created by Zakk Hoyt 2023
// Copyright © 2023 Zakk Hoyt. All rights reserved.
//

import Foundation

public struct AppTargetService {
    
}
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



/// ##
/// ## iPad/iPhone (device)
/// ```sh
/// Bundle.main.bundleURL -> ""
/// ```
///
/// ## Designed for iPad/iPhone
/// ```sh
/// Bundle.main.bundleURL -> "file:///private/var/folders/kd/jr06zppx451b4kwyd2_bp9nc0000gn/X/8C0584F9-69A6-5E59-93F0-0643DD397318/d/Wrapper/WalkingSkeletonApp.app"
/// ```
///
/// ## iOS Simulator
/// ```sh
/// Bundle.main.bundleURL -> "file:///$HOME/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Bundle/Application/A9A1A99E-3828-4D4C-BE23-0E7C0D8C518B/WalkingSkeletonApp.app"
///
/// ```
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
            infoDictionary:\n\(infoDictionarySummary())
        """
    }
    
    public func infoDictionarySummary() -> String {
        let infoDictionary: [String: Any] = infoDictionary ?? [:]
        let keys = infoDictionary.keys.sorted()
        return keys.enumerated().map {
            let (index, key) = $0
            guard let value = infoDictionary [key] else {
                return "        [\(index)] infoDictionary[\(key)]: <nil>"
            }
            return "        [\(index)] infoDictionary[\(key)]: \(String(describing: value))"
        }.joined(separator: "\n")
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
    /// Returns a `URL` pointing to the shared app group directory.
    /// - Remark: Return value will vary depending on the current build configuration.
    ///
    /// ## SeeAlso
    ///
    /// `"group.co.z2k.test"`
    public static func appGroupDirURL(
        appGroupIdentifier: String
    ) -> URL? {
        guard let url = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: appGroupIdentifier
        ) else {
            return nil
        }
        return url
    }


#warning("TODO: zakkhoyt - move to Bundle extension")
    public static let bundleModuleURL: URL = Bundle.module.bundleURL
    

    
    
    
    
    
    
    // MARK: Public static vars
    
#warning("FIXME: zakkhoyt - rename to applicationSandboxDirURL")
    /// Returns the directory of the application sandbox.
    ///
    /// ## Dirs
    /// * `iOSDevice`: `/private/var/mobile/Containers/Data/Application/DE66ABF6-E995-4D44-8CFE-95820C32FA4D`
    /// * `iOSSimulator`: `$HOME/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD`
    /// * `macDesignedForIPhoneIPad`: `$HOME/Library/Containers/co.z2k.CameraPreviewUI/Data`
    /// * `macCatalyst`: `$HOME/Library/Containers/co.z2k.CameraPreviewUI/Data`
    /// * `macNative`: `$HOME/Library/Containers/co.z2k.CameraPreviewUI/Data`
    ///
    /// ```sh
    /// # iOSDevice
    /// /private/var/mobile/Containers/Data/Application/DE66ABF6-E995-4D44-8CFE-95820C32FA4D
    ///
    /// # iOSSimulator
    /// $HOME/Library/Developer/CoreSimulator/Devices/43D5227F-BCA2-4663-B23E-8B0992ACDB89/data/Containers/Data/Application/4931D44C-C9E6-4298-B41F-68929B9D47CD
    ///
    /// # macDesignedForIPhoneIPad
    /// $HOME/Library/Containers/co.z2k.CameraPreviewUI/Data
    ///
    /// # macCatalyst
    /// $HOME/Library/Containers/co.z2k.CameraPreviewUI/Data
    ///
    /// # macNative
    /// $HOME/Library/Containers/co.z2k.CameraPreviewUI/Data
    /// ```
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
    
    public static let applicationDirectoryURL: URL = {
        guard let path = NSSearchPathForDirectoriesInDomains(
            .applicationDirectory, .userDomainMask, true
        ).first else {
            preconditionFailure("Failed to get path for .documentDirectory")
        }
        return URL(fileURLWithPath: path).preferCanonicalURL
    }()

    

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



