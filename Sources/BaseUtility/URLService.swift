//
//  URLService.swift
//  BaseUtility
//
//  Created by Zakk Hoyt 2023
//  Copyright © 2023 Zakk Hoyt. All rights reserved.
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
    
    public static var applicationDirURL: URL = documentsDirURL.deletingLastPathComponent()
    
    /// Returns the `Documents` directory in the application sandbox.
    public static var documentsDirURL: URL = {
        guard let path = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true
        ).first else {
            preconditionFailure("Failed to get path for .documentDirectory")
        }
        return URL(fileURLWithPath: path)
    }()
    
    /// Returns the `Library` directory in the application sandbox.
    public static var libraryDirURL: URL = {
        guard let path = NSSearchPathForDirectoriesInDomains(
            .libraryDirectory, .userDomainMask, true
        ).first else {
            preconditionFailure("Failed to get path for .libraryDirectory")
        }
        return URL(fileURLWithPath: path)
    }()
    
    /// Returns the `Library/Preferences` directory in the application sandbox.
    public static var preferencesDirUrl = libraryDirURL.appendingPathComponent("Preferences")
    
    /// Returns a `URL` pointing to the backing `plist` file for `UserDefaults.standard`.
    public static var standardUserDefaultsUrl: URL = {
        guard let mainBundleIdentifier = Bundle.main.bundleIdentifier else {
            preconditionFailure("Bundle.main.bundleIdentifier == nil")
        }
        return preferencesDirUrl
            .appendingPathComponent(mainBundleIdentifier)
            .appendingPathExtension("plist")
    }()
    
    /// Returns a `URL` pointing to the backing `plist` file for `UserDefaults(suiteName:)`.
    public static func suiteUserDefaultsUrl(suiteName: String) -> URL {
        preferencesDirUrl
            .appendingPathComponent(suiteName)
            .appendingPathExtension("plist")
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
