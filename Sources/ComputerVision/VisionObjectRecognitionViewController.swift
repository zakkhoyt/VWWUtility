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
