//
//  File.swift
//  
//
//  Created by Zakk Hoyt on 2/27/24.
//

import Foundation
import UIKit
import Vision


class DetetctionDrawer {
    private let lastDraw = LastDraw()
    private var bufferSize: CGSize = .zero
    var rootLayer: CALayer?
    private var detectionOverlay: CALayer! = nil
    
    init(
        bufferSize: CGSize
    ) {
        self.bufferSize = bufferSize
    }
    
    func setupLayers(
        rootLayer: CALayer
    ) {
        self.rootLayer = rootLayer
        detectionOverlay = CALayer() // container layer that has all the renderings of the observations
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.bounds = CGRect(
            x: 0.0,
            y: 0.0,
            width: bufferSize.width,
            height: bufferSize.height
        )
        detectionOverlay.position = CGPoint(
            x: rootLayer.bounds.midX,
            y: rootLayer.bounds.midY
        )
        rootLayer.addSublayer(detectionOverlay)
    }
    
    func updateLayerGeometry(
        //        rootLayer: CALayer
    ) {
        //        self.rootLayer = rootLayer
        guard let rootLayer else {
            preconditionFailure("rootLayer == nil")
        }
        let bounds = rootLayer.bounds
        var scale: CGFloat
        
        let xScale: CGFloat = bounds.size.width / bufferSize.height
        let yScale: CGFloat = bounds.size.height / bufferSize.width
        
        scale = fmax(xScale, yScale)
        if scale.isInfinite { scale = 1.0 }
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        // rotate the layer into screen orientation and scale and mirror
        detectionOverlay.setAffineTransform(
            CGAffineTransform(
                rotationAngle: CGFloat(.pi / 2.0)
            ).scaledBy(x: scale, y: -scale)
        )
        // center the layer
        detectionOverlay.position = CGPoint(
            x: bounds.midX,
            y: bounds.midY
        )
        
        CATransaction.commit()
        
    }
    
    func drawVisionRequestResults(
        //        _ results: [Any]
        objectObservations: [VNRecognizedObjectObservation]
    ) {
        //        if let classificationObservations = requests as? [VNClassificationObservation] {
        //            classificationObservations.logHighestConfidence()
        //            return
        //        }
        //
        //        let objectObservations = results.compactMap { $0 as? VNRecognizedObjectObservation }
        
        // Keep last frame around, but only for so many frames.
        //        let isLastDrawStale = Date().timeIntervalSince(lastDrawDate) >= lastDrawThreshold
        let isLastDrawStale = lastDraw.isStale
        
        guard !objectObservations.isEmpty || isLastDrawStale else { return }
        
        if !objectObservations.isEmpty {
            logger.debug("---- new object observations (\(objectObservations.count))")
        }
        
        if isLastDrawStale {
            logger.debug("---- last draw is stale \(self.lastDraw.debugDescription)")
        }
        
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        
        detectionOverlay.sublayers = nil // remove all the old recognized objects
        
        objectObservations.forEach { [weak self] in
            guard let self else { return }
            
            $0.labels.logHighestConfidence()
            
            // Select only the label with the highest confidence.
            guard let highestConfidence = $0.labels.highestConfidence else { return }
            let objectRect = VNImageRectForNormalizedRect(
                $0.boundingBox,
                Int(bufferSize.width),
                Int(bufferSize.height)
            )
            let shapeLayer = self.createRoundedRectLayerWithBounds(objectRect)
            
            let textLayer = self.createTextSubLayerInBounds(
                objectRect,
                identifier: highestConfidence.identifier,
                confidence: highestConfidence.confidence
            )
            shapeLayer.addSublayer(textLayer)
            detectionOverlay.addSublayer(shapeLayer)
            
            lastDraw.didDraw(observation: highestConfidence)
        }
        
        //        lastDrawDate = Date()
        
        updateLayerGeometry()
        CATransaction.commit()
    }
    
    func createRoundedRectLayerWithBounds(
        _ bounds: CGRect
    ) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.name = "Found Object"
        //        let color = UIColor(red: 1, green: 1, blue: 0.2, alpha: 1)
        //        let color = UIColor.systemYellow
        shapeLayer.backgroundColor = color.withAlphaComponent(0.2).cgColor
        shapeLayer.borderWidth = 4
        shapeLayer.borderColor = color.cgColor
        shapeLayer.cornerRadius = 7
        return shapeLayer
    }
    
    private let color = UIColor.systemYellow
    private let shadowColor = UIColor.systemBackground
    func createTextSubLayerInBounds(
        _ bounds: CGRect,
        identifier: String,
        confidence: VNConfidence
    ) -> CATextLayer {
        //let color = UIColor(red: 1, green: 1, blue: 0.2, alpha: 1)
        //        let color = UIColor.systemYellow
        //let shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
        //        let shadowColor = UIColor.systemBackground
        
        let textLayer = CATextLayer()
        textLayer.name = "Object Label"
        
        let text = String(format: "\(identifier)\nConfidence:  %.3f", confidence)
        let formattedString = NSMutableAttributedString(
            string: text
        )
        // Color the whole string
        formattedString.addAttributes(
            [
                .font: UIFont.preferredFont(forTextStyle: .caption2),
                .foregroundColor: UIColor.systemRed,
                .shadow: {
                    let shadow = NSShadow()
                    shadow.shadowColor = shadowColor
                    shadow.shadowOffset = CGSize(width: 2, height: 2)
                    shadow.shadowBlurRadius = 4.0
                    return shadow
                }()
            ],
            range: NSRange(location: 0, length: text.count)
        )
        // color only the identifier part of the string
        formattedString.addAttributes(
            [
                .font: UIFont.preferredFont(forTextStyle: .caption1),
                .foregroundColor: color
            ],
            range: NSRange(location: 0, length: identifier.count)
        )
        
        textLayer.string = formattedString
        textLayer.bounds = CGRect(
            x: 0,
            y: 0,
            width: bounds.size.height - 10,
            height: bounds.size.width - 10
        )
        textLayer.position = CGPoint(
            x: bounds.midX,
            y: bounds.midY
        )
        
        //        textLayer.shadowColor = shadowColor.cgColor
        //        textLayer.shadowOpacity = 0.7
        //        textLayer.shadowOffset = CGSize(
        //            width: 2,
        //            height: 2
        //        )
        //
        //        textLayer.foregroundColor = UIColor.systemRed.cgColor
        textLayer.contentsScale = 1.0 // retina rendering
        
        // rotate the layer into screen orientation and scale and mirror
        textLayer.setAffineTransform(
            CGAffineTransform(
                rotationAngle: UIDevice.current.orientation.affineRotateAngle
            ).scaledBy(x: 1.0, y: -1.0)
        )
        return textLayer
    }
    
}
