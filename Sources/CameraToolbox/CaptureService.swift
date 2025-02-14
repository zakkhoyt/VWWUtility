/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Contains the view controller for the Breakfast Finder.
*/

import AVFoundation
import SwiftUI

public protocol VideoDataOutputObservable {
    var videoDataOutput: AVCaptureVideoDataOutput { get }
    var videoDataOutputQueue: DispatchQueue  { get }
    var videoDataOutputDelegate: (any AVCaptureVideoDataOutputSampleBufferDelegate)? { get }
}


/// ## References
///
/// * [Apple: AVCam building a camera app](https://developer.apple.com/documentation/avfoundation/capture_setup/avcam_building_a_camera_app)
///
@available(macCatalyst 17.0, *)
public actor CaptureService: NSObject {
    enum Error: LocalizedError {
        case custom(String)
        case addInputFailed(message: String)
        case addOutputFailed(message: String)
    }
    
    /// An enumeration of the capture modes that the camera supports.
    public enum CaptureMode: String, Identifiable, CaseIterable {
        public var id: Self { self }
        /// A mode that enables photo capture.
        case photo
        
        /// A mode that enables video capture.1
        case video
        
        public var systemName: String {
            switch self {
            case .photo: "camera.fill"
            case .video: "video.fill"
            }
        }
    }

    /// A type that connects a preview destination with the capture session.
    nonisolated let previewSource: any PreviewSource
    
    private let captureSession = AVCaptureSession()
    private let captureDeviceExplorer = CaptureDeviceExplorer()
    private var currentDeviceInput: AVCaptureDeviceInput?
    
    
//    private let videoDataOutput = AVCaptureVideoDataOutput()
//    private let videoDataOutputQueue = DispatchQueue(
//        label: "VideoDataOutput",
//        qos: .userInitiated, attributes: [],
//        autoreleaseFrequency: .workItem
//    )
//    private var videoDataOutputDelegate: (any AVCaptureVideoDataOutputSampleBufferDelegate)?
    
//    class ComputerVisionBufferDelegate: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    
//    private func getVideoDataOutputDelegate() -> (any AVCaptureVideoDataOutputSampleBufferDelegate)? {
//        videoDataOutputDelegate
//    }
//    
//    private func setVideoDataOutputDelegate(_ delegate: (any AVCaptureVideoDataOutputSampleBufferDelegate)?) {
//        videoDataOutputDelegate = delegate
//    }
    
    override public init() {
        logger.debug("\(#file) \(#function) \(#line)")
        
        // Create a source object to connect the preview view with the capture session.
        previewSource = DefaultPreviewSource(session: captureSession)
        
        super.init()
    }
    
    public func start() async throws {
        logger.debug("\(#file) \(#function) \(#line)")
        guard await isAuthorized else { return }
        guard !captureSession.isRunning else { return }
        try setupAVCapture()
        captureSession.startRunning()
        logger.debug("CaptureService: Did call session.startRunning")
    }
    
    public func stop() {
        logger.debug("\(#file) \(#function) \(#line)")
        self.captureSession.stopRunning()
    }
    
    // In iOS, directly configuring a capture device’s activeFormat property changes the capture session’s preset
    // to inputPriority. Upon making this change, the capture session no longer automatically configures the capture
    // format when you call the startRunning() method or call the commitConfiguration() method after changing the
    // session topology.
    public  func setCaptureFormat(
        _ captureFormat: AVCaptureDevice.Format,
        captureDevice: AVCaptureDevice
    ) {
        logger.debug("\(logger.codeLocation(), privacy: .public) Setting active format, maybe")
        captureDevice.activeFormat = captureFormat
    }
    
    /// Changes the device the service uses for video capture.
    public func setCaptureDevice(
        _ nextCaptureDevice: AVCaptureDevice
    ) {
        // The captureDevice currently being used.
        // This might be used to fall back on if error.
        guard let currentDeviceInput else {
            // Is this a problem?
            assertionFailure("currentDeviceInput is nil")
            return
        }
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        // Remove the existing video input before attempting to connect a new one.
        captureSession.removeInput(currentDeviceInput)
        do {
            // Attempt to connect a new input and device to the capture session.
            self.currentDeviceInput = try addInput(captureDevice: nextCaptureDevice)
//            // Configure a new rotation coordinator for the new device.
//            createRotationCoordinator(for: device)
//            // Register for device observations.
//            observeSubjectAreaChanges(of: device)
//            // Update the service's advertised capabilities.
//            updateCaptureCapabilities()
            
            // The app only calls this method in response to the user requesting to switch cameras.
            // Set the new selection as the user's preferred camera.
            AVCaptureDevice.userPreferredCamera = nextCaptureDevice
        } catch {
            logger.error("""
            Failed to set cameraCaptureDevice: \(nextCaptureDevice.description) with error: \
            \(error.localizedDescription). Falling back to \(currentDeviceInput.device.description)
            """)
            // fall back to the camera we were already using
            captureSession.addInput(currentDeviceInput)
        }
    }
    
    public func addVideoDataOutput(
        observer: any VideoDataOutputObservable
    ) throws {
        try addOutput(captureOutput: observer.videoDataOutput)
        observer.videoDataOutput.alwaysDiscardsLateVideoFrames = true
        let format: FourCharCode = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange
        observer.videoDataOutput.videoSettings = [
            kCVPixelBufferPixelFormatTypeKey as String: format
        ]
        logger.debug("Configured videoDataOutput: \(format.stringRepresentation)")
        observer.videoDataOutput.setSampleBufferDelegate(observer.videoDataOutputDelegate, queue: observer.videoDataOutputQueue)
        logger.debug("Did set setSampleBufferDelegate for videoDataOutput to \(String(describing: observer.videoDataOutputDelegate))")
    }
    
    @available(macCatalyst 17.0, *)
    private func setupAVCapture() throws {
        logger.debug("\(#file) \(#function) \(#line)")
        logger.debug("setupAVCapture begin")
        
        guard let videoDevice = CaptureDeviceExplorer().defaultVideoCamera() else {
            throw Error.custom("CaptureService: Could not find a video device")
        }
        
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        try addInput(captureDevice: videoDevice)
        logger.debug("Did add video input: \(videoDevice)")
                        
        if let audioDevice = captureDeviceExplorer.defaultMirophone() {
            try addInput(captureDevice: audioDevice)
            logger.debug("Did add audio input: \(audioDevice)")
        } else {
            logger.debug("Skpped adding audio input: (no devices found)")
        }
        
        logger.debug("setupAVCapture finished")
    }
    
    // Adds an input to the capture session to connect the specified capture device.
    @discardableResult
    private func addInput(
        captureDevice: AVCaptureDevice
    ) throws -> AVCaptureDeviceInput {
        let captureDeviceInput = try AVCaptureDeviceInput(device: captureDevice)
        guard captureSession.canAddInput(captureDeviceInput) else {
            throw Error.addInputFailed(message: "Cannot add new input for device: \(captureDeviceInput.device.localizedName)")
        }
        captureSession.addInput(captureDeviceInput)
        logger.debug("Did add new input for device: \(captureDeviceInput.device.localizedName, privacy: .public)")
        return captureDeviceInput
    }
    
    private func addOutput(
        captureOutput: AVCaptureOutput
    ) throws {
        guard captureSession.canAddOutput(captureOutput) else {
            throw Error.addOutputFailed(message: "Failed to add output: \(captureOutput.description)")
        }
        captureSession.addOutput(captureOutput)
    }
    
    /// - Requires: `NSCameraUsageDescription`.
    /// Also `MacCatalyst` target requires `Camera` access in the `App Sandbox` settings
    /// - Requires: `NSMicrophoneUsageDescription`
    /// - Requires: `NSLocationWhenInUseUsageDescription`
    /// - Requires: `NSPhotoLibraryUsageDescription`
    /// - Remark: Optional `NSCameraUseContinuityCameraDeviceType`: YES
    /// - Requires: `UIFileSharingEnabled`
    var isAuthorized: Bool {
        get async {
            logger.debug("NSCameraUsageDescription: \(String(describing: Bundle.main.cameraUsageDescription))")
            logger.debug("NSMicrophoneUsageDescription: \(String(describing: Bundle.main.microphoneUsageDescription))")
            
            let authorizationStatus = AVCaptureDevice.authorizationStatus(for: .video)
            logger.debug("Camera permissions: initial authorizationStatus: \(authorizationStatus)")
            switch authorizationStatus {
            case .notDetermined:
                logger.debug("Camera permissions: authorizationStatus: \(authorizationStatus). Prompting...")
                return await withCheckedContinuation { continuation in
                    AVCaptureDevice.requestAccess(for: .video) { granted in
                        
                        
                        if granted {
                            logger.debug("Camera permissions: granted: \(granted)")
                            continuation.resume(with: .success(true))
                        } else {
                            
                            if ProcessInfo.processInfo.isMacCatalystApp {
                                logger.fault(
                                    """
                                    Camera permissions: granted: \(granted).
                                    \(Bundle.cameraUsageDeveloperTaskList)
                                    """
                                )
                            } else {
                                logger.fault(
                                    """
                                    Camera permissions: granted: \(granted).
                                    Does Info.plist include 'NSCameraUsageDescription', 'NSMicrophoneUsageDescription'?
                                    """
                                )
                            }
                            
                            continuation.resume(with: .success(false))
                        }
                    }
                }
                
            case .restricted:
                logger.debug("Camera permissions: User is not allowed to access media capture device.")
                return false
            case .denied:
                logger.debug("Camera permissions: User has denied accessing camera. Guide user to settings.")
                return false
            case .authorized:
                logger.debug("Camera permissions: Camera permission was granted")
                return true
            @unknown default:
                logger.debug("Camera permissions: Camera authorization status is unknown.")
                return false
            }
        }
    }
    
    private var previewLayer: AVCaptureVideoPreviewLayer {
        guard let previewLayer = captureSession.connections.compactMap({
            $0.videoPreviewLayer
        }).first else {
            preconditionFailure("captureSession.connection should contain a previewLayer. See AVCaptureConnection")
        }
        return previewLayer
    }
}

