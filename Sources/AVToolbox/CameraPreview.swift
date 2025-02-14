//
//  CameraPreview.swift
//  FileVault
//
//  Created by Zakk Hoyt on 2024-10-06.
//

@preconcurrency import AVFoundation
import SwiftUI
import UIKit

/// A protocol that enables a preview source to connect to a preview target.
///
/// The app provides an instance of this type to the client tier so it can connect
/// the capture session to the `PreviewView` view. It uses these protocols
/// to prevent explicitly exposing the capture objects to the UI layer.
///
protocol PreviewSource: Sendable {
    // Connects a preview destination to this source.
    func connect(to target: any PreviewTarget)
}

/// A protocol that passes the app's capture session to the `CameraPreview` view.
protocol PreviewTarget {
    // Sets the capture session on the destination.
    func setSession(_ session: AVCaptureSession)
}

/// The app's default `PreviewSource` implementation.
struct DefaultPreviewSource: PreviewSource {
    private let session: AVCaptureSession
    
    init(session: AVCaptureSession) {
        self.session = session
    }
    
    func connect(to target: any PreviewTarget) {
        target.setSession(session)
    }
}

public struct CaptureVideoPreviewView: UIViewRepresentable {
    public typealias UIViewType = CaptureView
    private let source: any PreviewSource
    
    init(source: any PreviewSource) {
        self.source = source
    }
    
    public func makeUIView(context: Context) -> UIViewType {
        let preview = CaptureView()
        source.connect(to: preview)
        return preview
    }
    
    public func updateUIView(_ uiView: UIViewType, context: Context) {
        logger.debug("\(#file) \(#function) \(#line)")
    }
    
    /// A `UIView` with layer of type `AVCaptureVideoPreviewLayer`which renders camera preview
    public class CaptureView: UIView, PreviewTarget {
        init() {
            super.init(frame: .zero)
#if targetEnvironment(simulator)
            // The capture APIs require running on a real device. If running
            // in Simulator, display a static image to represent the video feed.
            let imageView = UIImageView(frame: UIScreen.main.bounds)
            imageView.image = UIImage(named: "video_mode")
            imageView.contentMode = .scaleAspectFill
            imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            imageView.backgroundColor = .green
            addSubview(imageView)
#endif
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        public override func layoutSubviews() {
            super.layoutSubviews()
            if let previewLayer = layer as? AVCaptureVideoPreviewLayer {
                previewLayer.frame = bounds
                logger.debug("did resize previewLayer \(self.bounds.debugDescription) \(previewLayer.bounds.debugDescription)")
                logger.debug("did resize previewLayer \(self.frame.debugDescription) \(previewLayer.frame.debugDescription)")
            }
            layer.sublayers?.compactMap {
                $0 as? AVCaptureVideoPreviewLayer
            }.forEach { previewLayer in
                previewLayer.frame = bounds
                logger.debug("did resize previewLayer (sublayer) \(self.bounds.debugDescription) \(previewLayer.bounds.debugDescription)")
                logger.debug("did resize previewLayer (sublayer) \(self.frame.debugDescription) \(previewLayer.frame.debugDescription)")
            }
        }
        
        // Use the preview layer as the view's backing layer.
        public override class var layerClass: AnyClass {
            AVCaptureVideoPreviewLayer.self
        }
        
        var previewLayer: AVCaptureVideoPreviewLayer {
            layer as! AVCaptureVideoPreviewLayer
        }
        
        nonisolated func setSession(_ session: AVCaptureSession) {
            // Connects the session with the preview layer, which allows the layer
            // to provide a live view of the captured content.
            Task { @MainActor in
                previewLayer.session = session
            }
        }

    }
}

