//
//  Bundle+InfoPlist.swift
//  FileVault
//
//  Created by Zakk Hoyt on 2024-10-06.
//

import Foundation

extension Bundle {
#warning(
    """
    TODO: zakkhoyt - 
    * Check cameraUsageDescription for more advice in log messages. 
    * Check microphoneUsageDescription for more advice in log messages.
    * Decorate/format a bit nicer. 
    """
)
    
    static let cameraUsageDeveloperTaskList: String = """
        Does Info.plist include 'NSCameraUsageDescription', 'NSMicrophoneUsageDescription'?,
        MacCatalyst. Double check: Target settings -> Signing and Capabilities -> App Sandbox -> Allow Camera Hardware?
        MacCatalyst. Double check: Check Target settings -> Signing and Capabilities -> App Sandbox -> Allow Audio Input Hardware?
        """

    ///
    /// - Requires: `NSCameraUsageDescription`.
    /// Also `MacCatalyst` target requires `Camera` access in the `App Sandbox` settings
    /// - Requires: `NSMicrophoneUsageDescription`
    
    public var cameraUsageDescription: String? {
        guard let value = object(forInfoDictionaryKey: "NSCameraUsageDescription" as String) as? String else {
            return nil
        }
        return value
    }
    public var microphoneUsageDescription: String? {
        guard let value = object(forInfoDictionaryKey: "NSMicrophoneUsageDescription" as String) as? String else {
            return nil
        }
        return value
    }
}
