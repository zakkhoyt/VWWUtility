//
// Classifier.swift
// ComputerVision
//
// Created by Zakk Hoyt on 02/27/24
//

import CoreML
import Foundation

public class Classifier {
    public static func test() {
        print("hi from classifier")
    }
}

extension MLModelConfiguration {
    public static var all: MLModelConfiguration {
        let config = MLModelConfiguration()
        config.computeUnits = .all
        return config
    }
}
