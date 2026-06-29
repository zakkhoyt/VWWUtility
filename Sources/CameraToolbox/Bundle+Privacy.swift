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
    FIX: zakkhoyt -
    
    * Acrually check for the presence of cameraUsageDescription. Throw errors with advice on how to fix.
        * If catalyst or mac, acrually check for the presence of `Camera` access in the `App Sandbox` settings
    * Acrually check for the presence of microphoneUsageDescription. Throw errors with advice on how to fix. 
        * If catalyst or mac, acrually check for the presence of hardening. Throw errors with advice on how to fix.
    
    * Similar for NSCameraUseContinuityCameraDeviceType
        /// - Requires: `NSLocationWhenInUseUsageDescription`
    * Similar for NSLocationWhenInUseUsageDescription
        /// - Requires: `NSPhotoLibraryUsageDescription`
    * Similar for NSPhotoLibraryUsageDescription
        /// - Remark: Optional `NSCameraUseContinuityCameraDeviceType`: YES
    * Similar for UIFileSharingEnabled
        /// - Requires: `UIFileSharingEnabled`
    """
    )
    
    static let cameraUsageDeveloperTaskList: String = """
        Does Info.plist include 'NSCameraUsageDescription', 'NSMicrophoneUsageDescription'?,
        MacCatalyst. Double check: Target settings -> Signing and Capabilities -> App Sandbox -> Allow Camera Hardware?
        MacCatalyst. Double check: Check Target settings -> Signing and Capabilities -> App Sandbox -> Allow Audio Input Hardware?
        """
    
    /// A copy of the `Privacy - Camera Usage Description` from `Info.plist`
    ///
    /// - Requires: `NSCameraUsageDescription`.
    /// For targets on `macOS`, you must also enable `Camera` access in the `App Sandbox` settings.
    ///
    /// - Remark: Pairs well with `NSMicrophoneUsageDescription`
    ///
    /// ## References
    /// - SeeAlso: [Requesting authorization to capture and save media](https://developer.apple.com/documentation/avfoundation/capture_setup/requesting_authorization_to_capture_and_save_media)
    public var cameraUsageDescription: String? {
        object(forInfoDictionaryKey: "NSCameraUsageDescription" as String) as? String
    }
    
    /// A copy of the value stored under the key `NSMicrophoneUsageDescription` / `Privacy - Microphone Usage Description` from `Info.plist`
    ///
    /// - Requires: This data is read from `Info.plist` under key `NSMicrophoneUsageDescription`
    /// For targets on `macOS`, you must also enable  `Audio Input` access in the `App Sandbox` settings
    ///
    /// ## References
    /// - SeeAlso: [Requesting authorization to capture and save media](https://developer.apple.com/documentation/avfoundation/capture_setup/requesting_authorization_to_capture_and_save_media)
    public var microphoneUsageDescription: String? {
        object(forInfoDictionaryKey: "NSMicrophoneUsageDescription" as String) as? String
    }
    
    public var cameraUseContinuityCameraDeviceType: String? {
        object(forInfoDictionaryKey: "NSCameraUseContinuityCameraDeviceType" as String) as? String
    }
        
    public var locationWhenInUseUsageDescription: String? {
        object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription" as String) as? String
    }
            
    public var photoLibraryUsageDescription: String? {
        object(forInfoDictionaryKey: "NSPhotoLibraryUsageDescription" as String) as? String
    }
                
    public var fileSharingEnabled: String? {
        object(forInfoDictionaryKey: "UIFileSharingEnabled" as String) as? String
    }
                    
    
}
    
