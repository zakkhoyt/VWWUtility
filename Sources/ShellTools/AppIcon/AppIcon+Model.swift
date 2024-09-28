//
//  AppIcon+Model.swift
//
//  Created by Zakk Hoyt on 10/22/21.
//

#if os(macOS)

import Foundation

extension AppIcon {
    // TODO: Consolidate this Icon and Contents.Icon
    public struct Icon {
        // TODO: Not sure if Sips supports jpg, but maybe stripping alpha instead
        public enum Format: String {
            case png
            case jpg
        }
        
        public enum Idiom: String, Codable {
            case universal
            case iPad = "ipad"
            case iPhone = "iphone"
            case car
            case watch
            case tv
            case mac
            case iOSMarketing = "ios-marketing"
        }

        public enum Platform: String, Codable {
            case iOS = "ios"
            // case iPhone = "iphone"
            // case car = "car"
            case watchOS = "watchos"
            // case tv
            
            #warning("FIXME: zakkhoyt - implement encoder/decoder to deal with mac case")
            // case macOS = "macos" // NOTE: Xcode expect platform to be nil when device in "mac" in Content.json
            
            // case iOSMarketing = "ios-marketing"
        }
        
        public let scale: CGFloat
        public let size: CGSize
        public let idiom: Idiom
        public let platform: Platform?
        public let format: Format
        public let appearances: [Contents.Icon.Appearance]?
        
        public init(
            scale: CGFloat,
            size: CGSize,
            idiom: Idiom,
            platform: Platform?,
            format: Format = .png,
            appearances: [Contents.Icon.Appearance]? = nil
        ) {
            self.scale = scale
            self.size = size
            self.idiom = idiom
            self.platform = platform
            self.format = format
            self.appearances = appearances
        }
        
        public init(
            scale: CGFloat,
            square: CGFloat,
            idiom: Idiom,
            platform: Platform? = nil,
            format: Format = .png,
            appearances: [Contents.Icon.Appearance]? = nil
        ) {
            self.scale = scale
            self.size = CGSize(width: square, height: square)
            self.idiom = idiom
            self.platform = platform
            self.format = format
            self.appearances = appearances
        }
    }
}

extension AppIcon {
    public struct Contents: Codable {
        // TODO: Join AppIcon.Icon, AppIcon.Contents.Icon
        public struct Info: Codable {
            public let author: String
            public let version: Int
        }
        
        // TODO: Rename? Icon vs Image
        public struct Icon: Codable {
            public enum Error: Swift.Error {
                case decodeScale(String)
            }
            
            public enum Appearance: Codable {
                public enum Error: Swift.Error {
                    case invalidAppearance(String)
                }

                enum AppearanceValue: String, Codable {
                    case luminosity
                    case contrast
                }

                public enum LuminosityValue: String, Codable {
                    case light
                    case dark
                }

                public enum ContrastValue: String, Codable {
                    case high
                }
                
                case luminosity(LuminosityValue)
                case contrast(ContrastValue)
                
                enum CodingKeys: String, CodingKey {
                    case appearance
                    case value
                }
                    
                public init(from decoder: any Decoder) throws {
                    let container = try decoder.container(keyedBy: CodingKeys.self)
                    let appearanceString = try container.decode(String.self, forKey: .appearance)
                    guard let appearance = AppearanceValue(rawValue: appearanceString) else {
                        throw Error.invalidAppearance(appearanceString)
                    }
                    switch appearance {
                    case .luminosity:
                        let luminosityValue = try container.decode(LuminosityValue.self, forKey: .value)
                        self = .luminosity(luminosityValue)
                    case .contrast:
                        let contrastValue = try container.decode(ContrastValue.self, forKey: .value)
                        self = .contrast(contrastValue)
                    }
                }
                
                public func encode(to encoder: any Encoder) throws {
                    var container = encoder.container(keyedBy: CodingKeys.self)
                    switch self {
                    case .luminosity(let luminosityValue):
                        try container.encode(AppearanceValue.luminosity, forKey: .appearance)
                        try container.encode(luminosityValue, forKey: .value)
                    case .contrast(let contrastValue):
                        try container.encode(AppearanceValue.contrast, forKey: .appearance)
                        try container.encode(contrastValue, forKey: .value)
                    }
                }
            }
            
            public enum Subtype: String, Codable {
                case macCatalyst = "mac-catalyst"
            }
            
            public enum Format: String, Codable {
                case png
                case jpg
            }
            
            /// The file name of the icon (relative to this dir)
            public let fileName: String?
            
            // ls | grep .appiconset | xargs find | grep Contents | xargs grep idiom
            /// The idiom
            public let idiom: AppIcon.Icon.Idiom

            public let platform: AppIcon.Icon.Platform?
            
            /// The scale of the icon:
            public let scale: CGFloat?
            
            /// This size of the icon. EX: "1024x1024"
            public let size: CGSize
            
            public let unassigned: Bool?
            
            public let subtype: Subtype?
            
            public let appearances: [Appearance]?
            
            public init(
                fileName: String?,
                idiom: AppIcon.Icon.Idiom,
                platform: AppIcon.Icon.Platform?,
                scale: CGFloat?,
                size: CGSize,
                unassigned: Bool? = nil,
                subtype: Subtype? = nil,
                appearances: [Appearance]? = nil
            ) {
                self.fileName = fileName
                self.idiom = idiom
                self.platform = platform
                self.scale = scale
                self.size = size
                self.unassigned = unassigned
                self.subtype = subtype
                self.appearances = appearances
            }
            
            // MARK: Implements Codable
            
            enum CodingKeys: String, CodingKey {
                case fileName = "filename"
                case scale
                case idiom
                case platform
                case size
                case unassigned
                case subtype
                case appearances
            }
            
            public init(from decoder: any Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.fileName = try container.decodeIfPresent(String.self, forKey: .fileName)
                self.idiom = try container.decode(AppIcon.Icon.Idiom.self, forKey: .idiom)
                self.platform = try container.decodeIfPresent(AppIcon.Icon.Platform.self, forKey: .platform)
                
                // TODO: Move "x" out of init to extension
                if let scaleString = try container.decodeIfPresent(String.self, forKey: .scale)?.replacingOccurrences(of: "x", with: "") {
                    self.scale = try CGFloat(scaleString: scaleString)
                } else {
                    self.scale = nil
                }
                
                let sizeString = try container.decode(String.self, forKey: .size)
                self.size = try CGSize(from: sizeString)
                
                self.unassigned = try container.decodeIfPresent(Bool.self, forKey: .unassigned)
                self.subtype = try container.decodeIfPresent(Subtype.self, forKey: .subtype)
                self.appearances = try container.decodeIfPresent([Appearance].self, forKey: .appearances)
            }
            
            public func encode(to encoder: any Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                try container.encodeIfPresent(fileName, forKey: .fileName)
                try container.encode(idiom, forKey: .idiom)
                try container.encodeIfPresent(platform, forKey: .platform)
                if let scaleString = scale?.scaleString {
                    try container.encode(scaleString, forKey: .scale)
                }
                try container.encode("\(size.width.precisionString(mantissaCount: 1))x\(size.height.precisionString(mantissaCount: 1))", forKey: .size)
                try container.encodeIfPresent(unassigned, forKey: .unassigned)
                try container.encodeIfPresent(subtype, forKey: .subtype)
                try container.encodeIfPresent(appearances, forKey: .appearances)
            }
        }
        
        public let info: Contents.Info
        public let images: [Contents.Icon]
    }
}

extension CGFloat {
    init(scaleString: String) throws {
        guard let scale = Double(scaleString) else {
            throw AppIcon.Contents.Icon.Error.decodeScale(scaleString)
        }
        self.init(scale)
    }
    
    var scaleString: String {
        "\(precisionString(mantissaCount: 1))x"
    }
}

extension CGSize {
    fileprivate enum Error: Swift.Error {
        case invalidSizeString
        case invalidSizeValue
    }
    
    fileprivate init(from sizeString: String) throws {
        // Convert a size string to a CGSize
        let parts: [String] = sizeString.split(separator: "x").map { String($0) }
        guard parts.count == 2 else {
            throw Error.invalidSizeString
        }
        guard let width = Double(parts[0]) else {
            throw Error.invalidSizeValue
        }
        guard let height = Double(parts[1]) else {
            throw Error.invalidSizeValue
        }
        self.init(width: width, height: height)
    }
}

#endif
