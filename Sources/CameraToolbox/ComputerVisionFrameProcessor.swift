//
//  ComputerVisionBufferDelegate.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 2/14/25.
//

import AVFoundation
import SwiftUI
import Vision

public final class ComputerVisionBufferHandler: VideoDataOutputObservable {
    public let videoDataOutput = AVCaptureVideoDataOutput()
    public let videoDataOutputDelegate: (any AVCaptureVideoDataOutputSampleBufferDelegate)?
    public let videoDataOutputQueue = DispatchQueue(
        label: "VideoDataOutput",
        qos: .userInitiated, attributes: [],
        autoreleaseFrequency: .workItem
    )
    
    private let bufferProvider = ComputerVisionBufferProvider()
    
#warning("TODO: zakkhoyt - Pass in vision request, then emit detected data")
    public init() {
        videoDataOutputDelegate = bufferProvider
    }
    
    private var requests = [VNRequest]()
    
    func start() {
        bufferProvider.frameCaptured = { pixelBuffer in
            do {
#warning("FIXME: zakkhoyt - use convert to normalized coornidates")
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
}


class ComputerVisionBufferProvider: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    var frameCaptured: ((CVPixelBuffer) -> Void) = { _ in }

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
        frameCaptured(pixelBuffer)
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
