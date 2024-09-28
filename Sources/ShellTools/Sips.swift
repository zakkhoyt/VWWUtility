//
//  Sips.swift
//  A wrapper around the command line tool, sips.
//
//  Created by Zakk Hoyt on 10/7/21.
//

#if os(macOS)

import Foundation

public struct Sips: Shellable {
    public static let binaryPath = "/usr/bin/sips"
    public static let binaryUrl = URL(fileURLWithPath: binaryPath)
    
    public enum Option {
        static let getProperty = "--getProperty"
        static let resampleHeightWidth = "--resampleHeightWidth"
        static let output = "--out"
        static let setProperty = "--setProperty"
    }
    
    public enum ImageProperty: String {
        case dpiHeight
        case dpiWidth
        case pixelHeight
        case pixelWidth
        case typeIdentifier
        case format
        case formatOptions
        case space
        case samplesPerPixel
        case bitsPerSample
        case creation
        case make
        case model
        case software
        case description
        case copyright
        case artist
        case profile
        case hasAlpha
    }
    
    // TODO: Convert to struct
    public enum Error: Swift.Error {
        case failedToRead(property: String)
        case failedToConvert(property: String, value: String)
        case failedToExecute(option: String)
        case failedToParseResult(result: String)
    }
    
    public static func getProperty(
        _ property: Sips.ImageProperty,
        inputFileUrl: URL
    ) throws -> String {
        // sips HatchSleep_qa_1024x1024.png -g pixelWidth
        let commandParts = [
            Sips.binaryPath,
            inputFileUrl.path,
            Sips.Option.getProperty, property.rawValue
        ]
        
        guard let result = Sips.legacyExecute(commandParts) else {
            throw Error.failedToRead(property: property.rawValue)
        }
        
        guard let valueString = result.split(separator: " ").last else {
            throw Error.failedToParseResult(result: result)
        }
        return String(valueString)
    }
    
    public static func getProperty(
        _ property: Sips.ImageProperty,
        inputFileUrl: URL
    ) throws -> CGFloat {
        let valueString: String = try getProperty(property, inputFileUrl: inputFileUrl)
        // CGFloat doesn't have init(String), but Double does (these are typealias'd)
        guard let value = Double(valueString) else {
            throw Error.failedToConvert(property: property.rawValue, value: String(valueString))
        }
        return value
    }
    
    /// Uses `sips` in a `Process` to execute the equivalent of:
    /// `sips -s format jpeg MyFileName_1024x1024.png --resampleHeightWidth width height --out HatchSleep_qa_wxh.png`
    public static func resizeImage(
        at inputFileUrl: URL,
        size: CGSize,
        format: String,
        outputFileUrl: URL
    ) throws -> URL {
        let commandParts: [String] = [
            Sips.binaryPath,
            inputFileUrl.path,
            "-s", "format", format,
            Sips.Option.resampleHeightWidth, String(Int(size.width)), String(Int(size.height)),
            Sips.Option.output, outputFileUrl.path
        ]
        guard let result = Sips.legacyExecute(commandParts) else {
            throw Error.failedToExecute(option: Sips.Option.resampleHeightWidth)
        }

        guard let outputFilePath = result.split(separator: " ").last else {
            throw Error.failedToParseResult(result: result)
        }
        return URL(fileURLWithPath: String(outputFilePath))
    }
    
    /// Uses `sips` in a `Process` to execute the equivalent of:
    /// `sips -s format jpeg MyFileName_1024x1024.png --resampleHeightWidth width height --out HatchSleep_qa_wxh.png`
    public static func resizeImage(
        at inputFileUrl: URL,
        size: CGSize,
        format: String,
        outputFileUrl: URL,
        completion: (Result<URL, Error>) -> Void
    ) {
//        // sips HatchSleep_qa_1024x1024.png -s format jpeg HatchSleep_qa_1024x1024.png --resampleHeightWidth width height --out HatchSleep_qa_wxh.png
//        let arguments = [
//            inputFileUrl.path,
//            Sips.Option.setProperty, Sips.ImageProperty.format.rawValue, format,
//            Sips.Option.resampleHeightWidth, String(Int(size.width)), String(Int(size.height)),
//            Sips.Option.output, outputFileUrl.path
//        ]
//
//        // TODO: can we use Async/Await here? Swift 5? comamnd line env?
//        try? Sips.process(
//            executableURL: Sips.binaryUrl,
//            arguments: arguments,
//            completion: { result in
//                switch result {
//                case .success:
//                    print("")
//                    assertionFailure("Implement me")
//                case .failure:
//                    print("")
//                    assertionFailure("Implement me")
//                }
//            }
//        )
    }
}

#endif
