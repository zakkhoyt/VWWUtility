/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Contains the view controller for the Breakfast Finder.
*/

import UIKit
import AVFoundation
import Vision

//class ViewController: UIViewController {
class CaptureSession: NSObject {
    
    var drawer = DetetctionDrawer(bufferSize: .zero)
    
    var bufferSize: CGSize = .zero
//    var rootLayer: CALayer! = nil
    
    
    private let session = AVCaptureSession()
    private let videoDataOutput = AVCaptureVideoDataOutput()
    
    private let videoDataOutputQueue = DispatchQueue(
        label: "VideoDataOutput",
        qos: .userInitiated, attributes: [],
        autoreleaseFrequency: .workItem
    )
    
    @IBOutlet weak private var previewView: UIView!
    private var previewLayer: AVCaptureVideoPreviewLayer! = nil

    private var requests = [VNRequest]()
    
    private var detectionOverlay: CALayer! = nil
    private let model: MLModel
    
    init(model: MLModel) {
        self.model = model
        super.init()
        setupAVCapture()
    }
    
    func setupAVCapture() {
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
            let dimensions = CMVideoFormatDescriptionGetDimensions((videoDevice?.activeFormat.formatDescription)!)
            bufferSize.width = CGFloat(dimensions.width)
            bufferSize.height = CGFloat(dimensions.height)
            videoDevice!.unlockForConfiguration()
        } catch {
            print(error)
        }
        session.commitConfiguration()
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = previewView.layer.bounds
        previewView.layer.addSublayer(previewLayer)
        
        // ---------------
        
        drawer = DetetctionDrawer(bufferSize: bufferSize)
        do {
            
#warning("TODO: zakkhoyt - external")
            drawer.setupLayers(rootLayer: previewView.layer)
#warning("TODO: zakkhoyt - external")
            drawer.updateLayerGeometry()
            try setupVision(model: model)
            
            // start the capture
            startCaptureSession()
        } catch {
            logger.error("\(error.localizedDescription)")
        }
    }
    
    private func setupVision(
        model: MLModel
    ) throws {
        self.requests = [
            VNCoreMLRequest(
                model: try VNCoreMLModel(
                    for: model
                )
            ) { [weak self] request, error in
                guard let self else { return }
                if let error {
                    logger.fault("\(error.localizedDescription)")
                }
                DispatchQueue.main.async {
                    guard let results = request.results else { return }
                    
                    #warning("FIXME: zakkhoyt - request vs results")
                    // Log output from
                    if let classificationObservations = self.requests as? [VNClassificationObservation] {
                        classificationObservations.logHighestConfidence()
                        return
                    }
                    
                    let objectObservations = results.compactMap { $0 as? VNRecognizedObjectObservation }
                    self.drawer.drawVisionRequestResults(objectObservations: objectObservations)
                }
            }
        ]
    }

    func startCaptureSession() {
        DispatchQueue.global().async {
            self.session.startRunning()
        }
    }
    
    // Clean up capture setup
    func teardownAVCapture() {
        previewLayer.removeFromSuperlayer()
        previewLayer = nil
    }
    
    private func exifOrientationFromDeviceOrientation() -> CGImagePropertyOrientation {
        switch UIDevice.current.orientation {
        case .portraitUpsideDown: .left
        case .landscapeLeft: .upMirrored
        case .landscapeRight: .down
        case .portrait: .up
        default: .up
        }
    }
}

extension CaptureSession: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(
        _ captureOutput: AVCaptureOutput,
        didDrop didDropSampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        // print("frame dropped")
    }
    
    func captureOutput(
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
                orientation: exifOrientationFromDeviceOrientation(),
                options: [:]
            ).perform(self.requests)
        } catch {
            print(error)
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
