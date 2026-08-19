/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Contains the view controller for the Breakfast Finder.
*/

import UIKit
import AVFoundation
import Vision

// caller needs to
//        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        previewLayer.frame = previewView.layer.bounds
//        previewView.layer.addSublayer(previewLayer)

public class CaptureSession: NSObject {
    public struct Observation {
        /// capture device dimensions
        public let bufferSize: CGSize
        
//        /// UIView with layer: AVCaptureVideoPreviewLayer
//        public let previewView: UIView
        
        /// A list of observations
        public let detections: [VNObservation]
    }
    
    public private(set) var bufferSize: CGSize = .zero
    
    
    private let session = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private let videoDataOutputQueue = DispatchQueue(
        label: "VideoDataOutput",
        qos: .userInitiated, attributes: [],
        autoreleaseFrequency: .workItem
    )
    
    
//    private var previewView: UIView
    public private(set) var previewLayer: AVCaptureVideoPreviewLayer?

    private var requests = [VNRequest]()
//    private var detectionOverlay: CALayer! = nil
    private let model: MLModel
    
    private var detection: (Observation) -> Void = { _ in }
    
    public init(
        model: MLModel
    ) {
        logger.debug("\(#file) \(#function) \(#line)")
        self.model = model
        super.init()
        setupAVCapture()
    }
    
    deinit {
        logger.debug("\(#file) \(#function) \(#line)")
        stop()
        teardownAVCapture()
    }
    

    public func start(
        detection: @escaping (Observation) -> Void
    ) {
        logger.debug("\(#file) \(#function) \(#line)")
//    ) async -> UIView {
        self.detection = detection
        
        DispatchQueue.global().async {
//        Task {
            self.session.startRunning()
        }
            
//        }
    }
    
    public func stop() {
        logger.debug("\(#file) \(#function) \(#line)")
        self.session.stopRunning()
    }
    
    //        bufferSize (capture device dimensions)
    //        previewView or previewLayer: UIView/AVCaptureVideoPreviewLayer
    //        callback to provide Vision results (for caller to render)
    private func setupAVCapture() {
        logger.debug("\(#file) \(#function) \(#line)")
        var deviceInput: AVCaptureDeviceInput!
        
        // Select a video device, make an input
        let videoDevice = AVCaptureDevice.DiscoverySession(
            deviceTypes: [
                .builtInWideAngleCamera
//                .builtInLiDARDepthCamera
            ],
            mediaType: .video,
            position: .back
        ).devices.first
        do {
            deviceInput = try AVCaptureDeviceInput(device: videoDevice!)
        } catch {
            print("Could not create video device input: \(error)")
            return
        }
        
        session.beginConfiguration()
        session.sessionPreset = .vga640x480 // Model image size is smaller.
        
        // Add a video input
        guard session.canAddInput(deviceInput) else {
            print("Could not add video device input to the session")
            session.commitConfiguration()
            return
        }
        session.addInput(deviceInput)
        if session.canAddOutput(videoDataOutput) {
            session.addOutput(videoDataOutput)
            // Add a video data output
            videoDataOutput.alwaysDiscardsLateVideoFrames = true
            videoDataOutput.videoSettings = [
                kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
            ]
            videoDataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            print("Could not add video data output to the session")
            session.commitConfiguration()
            return
        }
        
        let captureConnection = videoDataOutput.connection(with: .video)
        // Always process the frames
        captureConnection?.isEnabled = true
        do {
            try  videoDevice!.lockForConfiguration()
            let dimensions = CMVideoFormatDescriptionGetDimensions(
                (videoDevice?.activeFormat.formatDescription)!
            )
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        session.commitConfiguration()
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: session)
        
//        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
//        previewLayer.frame = previewView.layer.bounds
//        previewView.layer.addSublayer(previewLayer)
        
//        self.previewLayer = previewLayer
        
        // ---------------

        #warning("FIXME: zakkhoyt - Move to caller")
//        drawer = DetetctionDrawer(bufferSize: bufferSize)
        do {
//            drawer.setupLayers(rootLayer: previewView.layer)
//            drawer.updateLayerGeometry()
            try setupVision(model: model)
            
//            // start the capture
//            startCaptureSession()
            logger.debug("\(#file) \(#function) \(#line) did return normally")
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    private func setupVision(
        model: MLModel
    ) throws {
        logger.debug("\(#file) \(#function) \(#line)")
        self.requests = [
            VNCoreMLRequest(
                model: try VNCoreMLModel(
                    for: model
                )
            ) { [weak self] request, error in
                guard let self else { return }
//                logger.debug("\(#file) \(#function) \(#line) VNCoreMLRequest callback")
                if let error {
                    logger.fault("\(error.localizedDescription)")
                }
                
                DispatchQueue.main.async {
                    guard let results = request.results, !results.isEmpty else {
//                        logger.debug("\(#file) \(#function) \(#line) processing 0 results")
                        return
                    }
                    
                    
                    logger.debug("\(#file) \(#function) \(#line) processing \(results.count) results")
                    #warning("FIXME: zakkhoyt - request vs results")
                    // Log output from
                    if let classificationObservations = self.requests as? [VNClassificationObservation] {
                        classificationObservations.logHighestConfidence()
                        return
                    }
                    
                
                    #warning("FIXME: zakkhoyt - callback to caller where rendering should occur")
//                    self.drawer.drawVisionRequestResults(
//                        objectObservations: results.compactMap { $0 as? VNRecognizedObjectObservation }
//                    )
                    
                    logger.debug("\(#file) \(#function) \(#line) calling into callback for self.detection")
                    self.detection(
                        Observation(
                            bufferSize: self.bufferSize,
//                            previewView: self.previewView,
                            detections: results
                        )
                    )
                }
            }
        ]
    }
    
    // Clean up capture setup
    private func teardownAVCapture() {
        previewLayer?.removeFromSuperlayer()
        previewLayer = nil
    }
}

extension CaptureSession: AVCaptureVideoDataOutputSampleBufferDelegate {
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
            try VNImageRequestHandler(
                cvPixelBuffer: pixelBuffer,
                orientation: UIDevice.current.orientation.exifOrientation,
                options: [:]
            ).perform(self.requests)
        } catch {
            logger.error("\(error)")
        }
    }
}

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
