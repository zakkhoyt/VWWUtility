/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 Contains the object recognition view controller for the Breakfast Finder.
 */
// Update Xcode settings:
//  Add a .mlmodel or .mlproject file to xcode project
//  In project settings: `CoreML Model Class Generation Language` -> `Swift`
//
// CoreML: https://apple.github.io/coremltools/docs-guides/source/introductory-quickstart.html
//
// Kodeco: https://www.kodeco.com/5653-create-ml-tutorial-getting-started#toc-anchor-003
//
// Classify Image without bundling MLModel: https://developer.apple.com/documentation/vision/vnclassifyimagerequest
// Classifying Images for Categorization and Search: https://developer.apple.com/documentation/vision/classifying_images_for_categorization_and_search
//
// Model gallery: https://developer.apple.com/machine-learning/models/
// Create image classifier: https://developer.apple.com/documentation/createml/creating-an-image-classifier-model

import os
import UIKit
import AVFoundation
import Vision

class VisionObjectRecognitionViewController: UIViewController {
    private let lastDraw = LastDraw()

    private var detectionOverlay: CALayer! = nil
    
    // Vision parts
//    private var requests = [VNRequest]()
    
    
//    override func setupAVCapture() {
//        super.setupAVCapture()
//        do {
//            // setup Vision parts
//            setupLayers()
//            updateLayerGeometry()
//            try setupVision()
//            
//            // start the capture
//            startCaptureSession()
//        } catch {
//            logger.error("\(error.localizedDescription)")
//        }
//    }
    
//    func setupVision(
//        model: Model = .yolo50V3
//    ) throws {
//        self.requests = [
//            VNCoreMLRequest(
//                model: try VNCoreMLModel(
//                    for: try model.mlModel(
//                        config: {
//                            let config = MLModelConfiguration()
//                            config.computeUnits = .all
//                            return config
//                        }()
//                    )
//                )
//            ) { [weak self] request, error in
//                guard let self else { return }
//                if let error {
//                    logger.fault("\(error.localizedDescription)")
//                }
//                DispatchQueue.main.async {
//                    guard let results = request.results else { return }
//                    self.drawVisionRequestResults(results)
//                }
//            }
//        ]
//    }
    
//
//    
//    func drawVisionRequestResults(_ results: [Any]) {
//        if let classificationObservations = requests as? [VNClassificationObservation] {
//            classificationObservations.logHighestConfidence()
//            return
//        }
//        
//        let objectObservations = results.compactMap { $0 as? VNRecognizedObjectObservation }
//        
//        // Keep last frame around, but only for so many frames.
////        let isLastDrawStale = Date().timeIntervalSince(lastDrawDate) >= lastDrawThreshold
//        let isLastDrawStale = lastDraw.isStale
//        
//        guard !objectObservations.isEmpty || isLastDrawStale else { return }
//        
//        if !objectObservations.isEmpty {
//            logger.debug("---- new object observations (\(objectObservations.count))")
//        }
//        
//        if isLastDrawStale {
//            logger.debug("---- last draw is stale \(self.lastDraw.debugDescription)")
//        }
//        
//        CATransaction.begin()
//        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
//
//        detectionOverlay.sublayers = nil // remove all the old recognized objects
//        
//        objectObservations.forEach { [weak self] in
//            guard let self else { return }
//            
//            $0.labels.logHighestConfidence()
//            
//            // Select only the label with the highest confidence.
//            guard let highestConfidence = $0.labels.highestConfidence else { return }
//            let objectRect = VNImageRectForNormalizedRect(
//                $0.boundingBox,
//                Int(bufferSize.width),
//                Int(bufferSize.height)
//            )
//            let shapeLayer = self.createRoundedRectLayerWithBounds(objectRect)
//            
//            let textLayer = self.createTextSubLayerInBounds(
//                objectRect,
//                identifier: highestConfidence.identifier,
//                confidence: highestConfidence.confidence
//            )
//            shapeLayer.addSublayer(textLayer)
//            detectionOverlay.addSublayer(shapeLayer)
//            
//            lastDraw.didDraw(observation: highestConfidence)
//        }
//        
////        lastDrawDate = Date()
//        
//        updateLayerGeometry()
//        CATransaction.commit()
//    }
//    
    
//    func setupLayers() {
//        detectionOverlay = CALayer() // container layer that has all the renderings of the observations
//        detectionOverlay.name = "DetectionOverlay"
//        detectionOverlay.bounds = CGRect(
//            x: 0.0,
//            y: 0.0,
//            width: bufferSize.width,
//            height: bufferSize.height
//        )
//        detectionOverlay.position = CGPoint(
//            x: rootLayer.bounds.midX,
//            y: rootLayer.bounds.midY
//        )
//        rootLayer.addSublayer(detectionOverlay)
//    }
//    
//    func updateLayerGeometry() {
//        let bounds = rootLayer.bounds
//        var scale: CGFloat
//        
//        let xScale: CGFloat = bounds.size.width / bufferSize.height
//        let yScale: CGFloat = bounds.size.height / bufferSize.width
//        
//        scale = fmax(xScale, yScale)
//        if scale.isInfinite { scale = 1.0 }
//        
//        CATransaction.begin()
//        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
//        
//        // rotate the layer into screen orientation and scale and mirror
//        detectionOverlay.setAffineTransform(
//            CGAffineTransform(
//                rotationAngle: CGFloat(.pi / 2.0)
//            ).scaledBy(x: scale, y: -scale)
//        )
//        // center the layer
//        detectionOverlay.position = CGPoint(
//            x: bounds.midX,
//            y: bounds.midY
//        )
//        
//        CATransaction.commit()
//        
//    }
    
//    private let color = UIColor.systemYellow
//    private let shadowColor = UIColor.systemBackground
//    func createTextSubLayerInBounds(
//        _ bounds: CGRect,
//        identifier: String,
//        confidence: VNConfidence
//    ) -> CATextLayer {
//        //let color = UIColor(red: 1, green: 1, blue: 0.2, alpha: 1)
////        let color = UIColor.systemYellow
//        //let shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
////        let shadowColor = UIColor.systemBackground
//
//        let textLayer = CATextLayer()
//        textLayer.name = "Object Label"
//    
//        let text = String(format: "\(identifier)\nConfidence:  %.3f", confidence)
//        let formattedString = NSMutableAttributedString(
//            string: text
//        )
//        // Color the whole string
//        formattedString.addAttributes(
//            [
//                .font: UIFont.preferredFont(forTextStyle: .caption2),
//                .foregroundColor: UIColor.systemRed,
//                .shadow: {
//                    let shadow = NSShadow()
//                    shadow.shadowColor = shadowColor
//                    shadow.shadowOffset = CGSize(width: 2, height: 2)
//                    shadow.shadowBlurRadius = 4.0
//                    return shadow
//                }()
//            ],
//            range: NSRange(location: 0, length: text.count)
//        )
//        // color only the identifier part of the string
//        formattedString.addAttributes(
//            [
//                .font: UIFont.preferredFont(forTextStyle: .caption1),
//                .foregroundColor: color
//            ],
//            range: NSRange(location: 0, length: identifier.count)
//        )
//        
//        textLayer.string = formattedString
//        textLayer.bounds = CGRect(
//            x: 0,
//            y: 0,
//            width: bounds.size.height - 10,
//            height: bounds.size.width - 10
//        )
//        textLayer.position = CGPoint(
//            x: bounds.midX,
//            y: bounds.midY
//        )
//
////        textLayer.shadowColor = shadowColor.cgColor
////        textLayer.shadowOpacity = 0.7
////        textLayer.shadowOffset = CGSize(
////            width: 2,
////            height: 2
////        )
////        
////        textLayer.foregroundColor = UIColor.systemRed.cgColor
//        textLayer.contentsScale = 1.0 // retina rendering
//        
//        // rotate the layer into screen orientation and scale and mirror
//        let angle: CGFloat = switch UIDevice.current.orientation {
//        case .unknown:
//            CGFloat(.pi / 2.0)
//        case .portrait:
//            CGFloat(.pi / 2.0)
//        case .portraitUpsideDown:
//            3 * CGFloat(.pi / 2.0)
//        case .landscapeLeft:
//            0 * CGFloat(.pi / 2.0)
//        case .landscapeRight:
//            2 * CGFloat(.pi / 2.0)
//        case .faceUp:
//            CGFloat(.pi / 2.0)
//        case .faceDown:
//            CGFloat(.pi / 2.0)
//        }
//        textLayer.setAffineTransform(
//            CGAffineTransform(
//                //rotationAngle: CGFloat(.pi / 2.0)
//                rotationAngle: angle
//            ).scaledBy(x: 1.0, y: -1.0)
//        )
//        return textLayer
//    }
    
//    func createRoundedRectLayerWithBounds(
//        _ bounds: CGRect
//    ) -> CALayer {
//        let shapeLayer = CALayer()
//        shapeLayer.bounds = bounds
//        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
//        shapeLayer.name = "Found Object"
////        let color = UIColor(red: 1, green: 1, blue: 0.2, alpha: 1)
////        let color = UIColor.systemYellow
//        shapeLayer.backgroundColor = color.withAlphaComponent(0.2).cgColor
//        shapeLayer.borderWidth = 4
//        shapeLayer.borderColor = color.cgColor
//        shapeLayer.cornerRadius = 7
//        return shapeLayer
//    }
    
}

extension Collection where Element: VNClassificationObservation {
    func logHighestConfidence() {
        guard let highestConfidence else { return }
        logger.debug("\(highestConfidence.identifier) \(String(format: "%.03f", highestConfidence.confidence))")
    }
    
    var highestConfidence: Element? {
        sorted { $0.confidence > $1.confidence }.first
    }
}

class LastDraw: CustomDebugStringConvertible {
    private let threshold = TimeInterval(0.5)
    private var lastDate: Date?
    var lastObservation: VNClassificationObservation?
    
    func didDraw(
        observation: VNClassificationObservation?
    ) {
        if let observation {
            lastObservation = observation
            lastDate = Date()
        } else {
            lastObservation = nil
            lastDate = nil
        }
    }
    
    var elapsed: TimeInterval? {
        guard let lastDate else {
            return nil
        }
        return Date().timeIntervalSince(lastDate)
    }
    
    var elapsedString: String {
        guard let elapsed else { return "n/a" }
        return String(format: "%.03f", elapsed)
    }
    
    var lastObservationString: String {
        lastObservation?.identifier ?? "n/a"
    }
    
    var isStale: Bool {
        guard let elapsed else { return true }
        if elapsed >= threshold {
            return true
        } else {
            return false
        }
    }
    
    var debugDescription: String {
            """
            isStale: \(isStale) elapsed: \(elapsedString) observation: \(lastObservationString)
            """
    }
}

//enum Model: CustomStringConvertible {
//    
//    //    case mobileNetV1
//    case mobileNetV2
//    case resNet50
//    case squeezeNet
//    
//    case objectDetector
//    case yolo50V3Tiny
//    case yolo50V3
//    
//    var description: String {
//        switch self {
//            //        case .mobileNetV1: "mobileNetV1"
//        case .mobileNetV2: "mobileNetV2"
//        case .resNet50: "resNet50"
//        case .squeezeNet: "squeezeNet"
//        case .objectDetector: "objectDetector"
//        case .yolo50V3Tiny: "yolo50V3Tiny"
//        case .yolo50V3: "yolo50V3"
//        }
//    }
//    
//    
//    func mlModel(
//        config: MLModelConfiguration
//    ) throws -> MLModel {
//
////        try YOLOv3Tiny(configuration: config).model
////        switch self {
////            //            case .mobileNetV1: try? MobileNetV2(configuration: defaultConfig).model
////        case .mobileNetV2: try MobileNetV2(configuration: config).model
////        case .resNet50: try Resnet50(configuration: config).model
////        case .squeezeNet: try SqueezeNet(configuration: config).model
////        case .objectDetector: try ObjectDetector(configuration: config).model
////        case .yolo50V3Tiny: try YOLOv3Tiny(configuration: config).model
////        case .yolo50V3: try YOLOv3(configuration: config).model
////        }
//    }
//}
//
//
