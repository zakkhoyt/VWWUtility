//
//  DeviceIterator.swift
//  FileVault
//
//  Created by Zakk Hoyt on 2024-10-06.
//

import AVFoundation
import BaseUtility

@available(macCatalyst 17.0, *)
public final class CaptureDeviceExplorer {
#warning("TODO: zakkhoyt - use kvo to auto detect")
    
    private let frontCameras = AVCaptureDevice.DiscoverySession(
        deviceTypes: .cameraDeviceTypes_iOS,
        mediaType: .video,
        position: .front
    )
    
    private let backCameras = AVCaptureDevice.DiscoverySession(
        deviceTypes: .cameraDeviceTypes_iOS,
        mediaType: .video,
        position: .back
    )
    
    private let externalCameras = AVCaptureDevice.DiscoverySession(
        deviceTypes: .cameraDeviceTypes_macOS,
        mediaType: .video,
        position: .unspecified
    )
    
    private let depthDataCameras = AVCaptureDevice.DiscoverySession(
        deviceTypes: [
            .builtInTrueDepthCamera,
            .builtInLiDARDepthCamera
        ],
        mediaType: .video,
        position: .unspecified
    )
    
    private let microphones = AVCaptureDevice.DiscoverySession(
        deviceTypes: [.microphone],
        mediaType: .audio,
        position: .unspecified
    )
    
    public init() {
        let frontCamerasDescription = frontCameras.devices.map { $0.debugDescription }.listDescription()
        logger.debug("Explorer found [\(self.frontCameras.devices.count)] front cameras: \(frontCamerasDescription, privacy: .public)")
        
        let backCamerasDescription = backCameras.devices.map { $0.debugDescription }.listDescription()
        logger.debug("Explorer found [\(self.backCameras.devices.count)] back cameras: \(backCamerasDescription, privacy: .public)")
        
        let externalCamerasDescription = externalCameras.devices.map { $0.localizedName }.listDescription()
        logger.debug("Explorer found [\(self.externalCameras.devices.count)] external cameras: \(externalCamerasDescription, privacy: .public)")

        let depthDataCamerasDescription = depthDataCameras.devices.map { $0.localizedName }.listDescription()
        logger.debug("Explorer found [\(self.depthDataCameras.devices.count)] depthData cameras: \(depthDataCamerasDescription, privacy: .public)")
        
        let microphonesDescription = microphones.devices.map { $0.localizedName }.listDescription()
        logger.debug("Explorer found [\(self.microphones.devices.count)] microphones: \(microphonesDescription, privacy: .public)")
    }
    
    public func allVideoCameras(
        position: AVCaptureDevice.Position = .unspecified
    ) -> [AVCaptureDevice] {
        externalCameras.devices + frontCameras.devices + backCameras.devices + depthDataCameras.devices
    }
    
    /// Can be filtered by `deviceType`, `position`, etc..
    public func defaultVideoCamera() -> AVCaptureDevice? {
        
        #if os(iOS)
//        if ProcessInfo.processInfo.isMacCatalystApp,
//           // For Designed or iPad, the built in facetime camra appears to cause a crash
//           // as noted https://developer.apple.com/forums/thread/745482
//            // Let's use an iPhone if available
//           let continuityCamera = frontCameras.devices
//            .first(where: {
//               $0.position == .front && $0.isContinuityCamera == true
//           }){
//            logger.debug("Since os is iOS and isMacCatalystApp == true, defaulting to continuity camera (if present). Using \(continuityCamera.description)")
//            return continuityCamera
//        } else {
//            logger.debug("Since os is iOS and isMacCatalystApp == true, defaulting to continuity camera (if present), but none found. Falling back to default")
//        }
        #elseif os(macOS)
        
        #endif
        
        
        if let userPreferredCamera = AVCaptureDevice.userPreferredCamera {
            return userPreferredCamera
        } else if let systemPreferredCamera = AVCaptureDevice.systemPreferredCamera {
            return systemPreferredCamera
        } else if let first = allVideoCameras().first {
            logger.debug("defaultVideoCamera returning first of \(self.allVideoCameras().count) cameras")
            return first
        } else {
            logger.warning("No cameraDevices were found")
            return nil
        }
    }
    
    
    public func allMicrophones(
        position: AVCaptureDevice.Position = .unspecified
    ) -> [AVCaptureDevice] {
        microphones.devices
    }
    
    /// Can be filtered by `deviceType`, `position`, etc..
    public func defaultMirophone() -> AVCaptureDevice? {
        microphones.devices.first
    }

}

@available(macCatalyst 17.0, *)
extension [AVCaptureDevice.DeviceType] {
    static let cameraDeviceTypes_iOS: Self = [
        .builtInWideAngleCamera,
        .builtInTelephotoCamera,
        .builtInUltraWideCamera,
        .builtInDualCamera,
        .builtInDualWideCamera,
        .builtInTripleCamera,
        .builtInTrueDepthCamera,
        .builtInLiDARDepthCamera
    ]
    
    static let cameraDeviceTypes_macOS: Self = [
        .external,
        .continuityCamera,
        //        .deskViewCamera,
        //        .companionDeskViewCamera,
        .builtInWideAngleCamera,
        .builtInTelephotoCamera,
        .builtInUltraWideCamera,
        .builtInDualCamera,
        .builtInDualWideCamera,
        .builtInTripleCamera,
        .builtInTrueDepthCamera,
        .builtInLiDARDepthCamera
    ]
}

extension [AVCaptureSession.Preset] {
    static let all: Self = [
        .photo, // photo quality
        .high, // default
        .medium,
        .low,
        .cif352x288,
        .vga640x480,
        .hd1280x720,
        .hd1920x1080,
        .hd4K3840x2160,
        .iFrame960x540,
        .iFrame1280x720,
        .inputPriority, // Defer to what was set using AVCaptureDevice.setActiveFormat(:)
    ]
}

