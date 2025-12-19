//
// Bundle+Version.swift
//
//
// Created by Zakk Hoyt on 12/4/23.
//

import CoreFoundation
import class Foundation.Bundle

// import HatchDevUtilities
#if os(iOS)
import UIKit
#endif

extension Bundle {
    /// Returns the `build` number of the bundle as a `String`
    public var buildString: String? { self[kCFBundleVersionKey] }
    
    /// Returns the `version` number of the bundle as a `String`
    /// - Important: This will return `nil` if called from unit tests
    public var versionString: String? { self["CFBundleShortVersionString"] }
    
    /// Returns the `version` number of the bundle as a `Version` type
    /// - Important: This will return `nil` if called from unit tests
    public var version: Version? {
        guard let versionString else { return nil }
        return Version(versionString)
    }
    
    public var versionAndBuildString: String? {
        guard let versionString,
              let buildString else {
            return nil
        }
        return "\(versionString) b\(buildString)"
    }
}

extension Bundle {
    public var appName: String? { self[kCFBundleNameKey] }
    
    public var bundleIdentifier: String? { self[kCFBundleIdentifierKey] }
    
    public var userAgent: String {
        get async {
            await Task {
                await MainActor.run {
                    var properties = [
                        "app": appName,
                        "appID": bundleIdentifier,
                        "versionNumber": versionString,
                        "buildNumber": buildString
                    ]
                    
#if os(iOS)
                    properties = properties.merging(
                        [
                            "os": UIDevice.current.systemName,
                            "osVersion": UIDevice.current.systemVersion,
                            "device": UIDevice.current.model,
                            "hardware": UIDevice.current.modelName
                        ]
                    ) { $1 }
#endif
                    return properties.compactMapValues { $0 }
                        .map { [$0, $1].joined(separator: "=") }
                        .joined(separator: " ")
                }
            }.value
        }
    }
}

extension Bundle {
    /// A wrapper to make retrieving values for `CFString` keys easier
    public subscript(key: CFString) -> String? {
        object(
            forInfoDictionaryKey: key as String
        ) as? String
    }
    
    /// A wrapper to make retrieving values for `CFString` keys easier
    public subscript(key: String) -> String? {
        object(
            forInfoDictionaryKey: key
        ) as? String
    }
}

#if os(iOS)

extension UIDevice {
    /// Provides a (somewhat) human relatable model string. EX: `iPhone15,3`
    ///
    /// ## References
    ///
    /// * [iPhone Model Reference](https://www.theiphonewiki.com/wiki/Models)
    public var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
}
#endif
