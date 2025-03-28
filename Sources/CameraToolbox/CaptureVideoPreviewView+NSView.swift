//
//  CaptureVideoPreviewView.swift
//  VWWUtility
//
//  Created by Zakk Hoyt on 2/14/25.
//


//#if canImport(AppKit)
#if os(macOS)
@preconcurrency import AVFoundation
import SwiftUI
import AppKit


public struct CaptureVideoPreviewView: NSViewRepresentable {
    public typealias NSViewType = CaptureView
    private let source: any PreviewSource
    
    init(source: any PreviewSource) {
        self.source = source
    }
    
    public func makeNSView(context: Context) -> NSViewType {
        let preview = CaptureView()
        source.connect(to: preview)
        return preview
    }

    public func updateNSView(_ nsView: NSViewType, context: Context) {
        logger.debug("\(#file) \(#function) \(#line)")
    }
    
    /// A `UIView` with layer of type `AVCaptureVideoPreviewLayer`which renders camera preview
    public class CaptureView: NSView, PreviewTarget {
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

        public override func viewDidEndLiveResize() {
            super.viewDidEndLiveResize()
            resizePreviewLayer()
        }
        
        public override func viewDidMoveToWindow() {
            super.viewDidMoveToWindow()
            resizePreviewLayer()
        }
        
        private func resizePreviewLayer() {
            if let previewLayer = layer as? AVCaptureVideoPreviewLayer {
                previewLayer.frame = bounds
                logger.debug("did resize previewLayer \(self.bounds.debugDescription) \(previewLayer.bounds.debugDescription)")
                logger.debug("did resize previewLayer \(self.frame.debugDescription) \(previewLayer.frame.debugDescription)")
            }
            layer?.sublayers?.compactMap {
                $0 as? AVCaptureVideoPreviewLayer
            }.forEach { previewLayer in
                previewLayer.frame = bounds
                logger.debug("did resize previewLayer (sublayer) \(self.bounds.debugDescription) \(previewLayer.bounds.debugDescription)")
                logger.debug("did resize previewLayer (sublayer) \(self.frame.debugDescription) \(previewLayer.frame.debugDescription)")
            }

        }
#warning("FIXME: zakkhoyt - support NSView")
//        override public var layer: CALayer? {
//            layer as! AVCaptureVideoPreviewLayer
//        }

//        // Use the preview layer as the view's backing layer.
//        public override class var layerClass: AnyClass {
//            AVCaptureVideoPreviewLayer.self
//        }
        
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

#endif
