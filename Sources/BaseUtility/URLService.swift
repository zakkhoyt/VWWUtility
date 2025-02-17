//
// URLService.swift
// BaseUtility
//
// Created by Zakk Hoyt 2023
// Copyright © 2023 Zakk Hoyt. All rights reserved.
//

import Foundation

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



