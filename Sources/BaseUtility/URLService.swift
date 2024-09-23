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
    // MARK: Public static vars
    
    public static let applicationDirURL: URL = documentsDirURL.deletingLastPathComponent()

//    /// Returns a `URL` pointing to the shared app group directory.
//    /// - Remark: Return value will vary depending on the current build configuration.
//    ///
//    /// ## SeeAlso
//    ///
//    /// `AppGroupIdentifier.hatchSleepApp.appGroupIdentifier`
//    ///
//    public static var appGroupDirUrl: URL = {
//        guard let url = FileManager.default.containerURL(
//            forSecurityApplicationGroupIdentifier: AppGroupIdentifier.hatchSleepApp.appGroupIdentifier
//        ) else {
//            preconditionFailure("Failed to get URL for app group \(AppGroupIdentifier.hatchSleepApp.appGroupIdentifier)")
//        }
//        return url
//    }()
    public static let bundleModuleURL: URL = Bundle.module.bundleURL
        
    /// Returns the `Documents` directory in the application sandbox.
    public static let documentsDirURL: URL = {
        guard let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first else {
            preconditionFailure("Failed to get path for .documentDirectory")
        }
        return URL(fileURLWithPath: path).preferCanonicalURL
    }()
    
    /// Returns the `Library` directory in the application sandbox.
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
