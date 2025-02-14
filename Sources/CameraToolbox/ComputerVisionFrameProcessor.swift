//
//  ComputerVisionBufferDelegate.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 2/14/25.
//

import AVFoundation
import SwiftUI
import Vision


class ComputerVisionBufferDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var requests = [VNRequest]()
    public func captureOutput(
        _ captureOutput: AVCaptureOutput,
        didDrop didDropSampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        // print("frame dropped")
    }
    
    public func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        do {
#if os(iOS)
            let orientation = UIDevice.current.orientation.exifOrientation
#elseif os(macOS)
            let orientation = CGImagePropertyOrientation.up
#endif
            try VNImageRequestHandler(
                cvPixelBuffer: pixelBuffer,
                orientation: orientation,
                options: [:]
            ).perform(self.requests)
        } catch {
            logger.error("\(error)")
        }
    }
}

#if os(iOS)
extension UIDeviceOrientation: CustomStringConvertible {
    public var description: String {
        switch self {
        case .unknown: "unknown"
        case .portrait: "portrait"
        case .portraitUpsideDown: "portraitUpsideDown"
        case .landscapeLeft: "landscapeLeft"
        case .landscapeRight: "landscapeRight"
        case .faceUp: "faceUp"
        case .faceDown: "faceDown"
        @unknown default: "@unknown default"
        }
    }
    
    
    var exifOrientation: CGImagePropertyOrientation {
        switch self {
        case .portraitUpsideDown: .left
        case .landscapeLeft: .upMirrored
        case .landscapeRight: .down
        case .portrait: .up
        case .unknown: .up
        case .faceUp: .up
        case .faceDown: .up
        @unknown default: .up
        }
    }
    
    // Returns a multiple of 90 degrees (in radians)
    var affineRotateAngle: CGFloat {
        .pi / 2 * {
            switch self {
            case .unknown: 1
            case .portrait: 1
            case .portraitUpsideDown: 3
            case .landscapeLeft: 0
            case .landscapeRight: 2
            case .faceUp: 1
            case .faceDown: 1
            @unknown default: 1
            }
        }()
    }
}
#endif
