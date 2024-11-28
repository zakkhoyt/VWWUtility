//
//  DoccSandboxApp.swift
//  DoccSandbox
//
//  Created by Zakk Hoyt on 2024-11-25.
//

import os.log
import Foundation
import SwiftUI
import UIKit

public struct Placehold {
    /// Returns a URL pointing to a `placeholder image`
    ///
    /// These images are computed with the attributes specified below using
    /// [placehold.co](https://placehold.co).
    ///
    /// ## Example Images
    /// ![example](https://placehold.co/600x400/EEE/31343C)
    ///
    /// ![red](https://placehold.co/44x44/FF0000/FF0000)
    ///
    /// - Parameters:
    ///   - size: Size of the image in pixesls.`.height` is optional
    ///   - backgroundColor: A `Color` to use for the background
    ///   - foregroundColor: A `Color` to use for the the text/foreground.
    ///   - format: Image format expressed as `Format`. Default format is `.svg`
    ///   - text: Optional `String` to render. `foregroundColor is used`.
    ///   - font: The font expressed as `Font`. Default value is `Font.lato`
    /// - Returns: A `URL` to the image. Otherwise `nil`.
    /// - SeeAlso: [placehold.co API](https://placehold.co/)
#warning("TODO: zakkhoyt - API supports 3 char hex colors. Do we care?")
#warning("TODO: zakkhoyt - Some formats support retina @2x")
    public static func url(
        size: Size = Size(width: 15, height: 15),
        backgroundColor: Color,
        foregroundColor: Color,
        format: Format? = nil,
        text: String? = nil,
        font: Font? = nil
    ) -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "placehold.co"
        urlComponents.path = [
            "", // forces `path` to begin with "/"
            size.description,
            backgroundColor.rgbHexString,
            foregroundColor.rgbHexString,
            format?.rawValue
        ]
            .compactMap { $0 }
            .joined(separator: "/")
        
        urlComponents.queryItems = {
            var queryItems: [URLQueryItem] = []
            if let font {
                queryItems.append(URLQueryItem(
                    name: "font",
                    value: font.rawValue
                ))
            }
            
            if let text {
                queryItems.append(URLQueryItem(
                    name: "text",
                    value: text
                ))
            }
            return queryItems
        }()
        
        guard let url = urlComponents.url else {
            #warning("FIXME: zakkhoyt - throw")
            logger.error("failed to create url from: \(urlComponents.debugDescription)")
            return nil
        }
        
        logger.debug("placehold url: \(url.absoluteString)")
        return url
    }
}

extension Placehold {
    public struct Size: CustomStringConvertible {
        public let width: UInt16
        public let height: UInt16?
        
        public var description: String {
            [ width, height ]
                .compactMap { $0 }
                .map { "\($0)"}
                .joined(separator: "x")
        }
        
        public init(width: UInt16, height: UInt16?) {
            self.width = width; self.height = height
        }
    }
    
    public enum Format: String, CaseIterable {
        case svg
        case png
        case jpeg
        case gif
        case webp
        
        public var description: String {
            ".\(rawValue)"
        }
    }
    
    public enum Font: String, CaseIterable {
        case lato
        case lora
        case montserrat
        case openSans = "open sans"
        case oswald
        case playfairDisplay = "playfair display"
        case ptSans = "pt sans"
        case raleway
        case roboto
        case sourceSansPro = "source sans pro"
        
        public var description: String {
            rawValue.capitalized
        }
    }
}

// MARK: Below here originates from HatchUtilities

extension Color {
    public init(
        hexString: String,
        opacity: Double = 1.0
    ) {
        let color = hexString.hexStringValue
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red = Double(r) / 255.0
        let green = Double(g) / 255.0
        let blue = Double(b) / 255.0
        
        self.init(red: red, green: green, blue: blue, opacity: opacity)
    }
    
    public init?(rgba: [Int]?) {
        guard let rgba, rgba.count == 4 else { return nil }
        self.init(
            red: Double(rgba[0]) / 255.0,
            green: Double(rgba[1]) / 255.0,
            blue: Double(rgba[2]) / 255.0,
            opacity: Double(rgba[3]) / 255.0
        )
    }
    
    public var rgbHexString: String {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return [ red, green, blue ]
            .map { UInt8($0) }
            .map { String(format: "%02X", $0) }
            .joined()
    }
}


extension String {
    var hexStringValue: UInt32 {
        let scanner = Scanner(string: self)
        scanner.charactersToBeSkipped = CharacterSet(arrayLiteral: "#")
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        return UInt32(color)
    }
}

/// ## Example
///
/// ```sh
/// https://placehold.co/600x400/000/FFF
/// https://placehold.co/300x100/000000/00FF00/gif?font=lato&text=.gif%0ALato
/// https://placehold.co/300x100/000000/00FF00/gif?font=lora&text=.gif%0ALora
/// https://placehold.co/300x100/000000/00FF00/gif?font=montserrat&text=.gif%0AMontserrat
/// https://placehold.co/300x100/000000/00FF00/gif?font=open%20sans&text=.gif%0AOpen%20Sans
/// https://placehold.co/300x100/000000/00FF00/gif?font=oswald&text=.gif%0AOswald
/// https://placehold.co/300x100/000000/00FF00/gif?font=playfair%20display&text=.gif%0APlayfair%20Display
/// https://placehold.co/300x100/000000/00FF00/gif?font=pt%20sans&text=.gif%0APt%20Sans
/// https://placehold.co/300x100/000000/00FF00/gif?font=raleway&text=.gif%0ARaleway
/// https://placehold.co/300x100/000000/00FF00/gif?font=roboto&text=.gif%0ARoboto
/// https://placehold.co/300x100/000000/00FF00/gif?font=source%20sans%20pro&text=.gif%0ASource%20Sans%20Pro
/// https://placehold.co/300x100/000000/00FF00/jpeg?font=lato&text=.jpeg%0ALato
/// https://placehold.co/300x100/000000/00FF00/jpeg?font=lora&text=.jpeg%0ALora
/// https://placehold.co/300x100/000000/00FF00/jpeg?font=montserrat&text=.jpeg%0AMontserrat
/// https://placehold.co/300x100/000000/00FF00/jpeg?font=open%20sans&text=.jpeg%0AOpen%20Sans
/// https://placehold.co/300x100/000000/00FF00/jpeg?font=oswald&text=.jpeg%0AOswald
/// https://placehold.co/300x100/000000/00FF00/jpeg?font=playfair%20display&text=.jpeg%0APlayfair%20Display
/// https://placehold.co/300x100/000000/00FF00/jpeg?font=pt%20sans&text=.jpeg%0APt%20Sans
/// https://placehold.co/300x100/000000/00FF00/jpeg?font=raleway&text=.jpeg%0ARaleway
/// https://placehold.co/300x100/000000/00FF00/jpeg?font=roboto&text=.jpeg%0ARoboto
/// https://placehold.co/300x100/000000/00FF00/jpeg?font=source%20sans%20pro&text=.jpeg%0ASource%20Sans%20Pro
/// https://placehold.co/300x100/000000/00FF00/png?font=lato&text=.png%0ALato
/// https://placehold.co/300x100/000000/00FF00/png?font=lora&text=.png%0ALora
/// https://placehold.co/300x100/000000/00FF00/png?font=montserrat&text=.png%0AMontserrat
/// https://placehold.co/300x100/000000/00FF00/png?font=open%20sans&text=.png%0AOpen%20Sans
/// https://placehold.co/300x100/000000/00FF00/png?font=oswald&text=.png%0AOswald
/// https://placehold.co/300x100/000000/00FF00/png?font=playfair%20display&text=.png%0APlayfair%20Display
/// https://placehold.co/300x100/000000/00FF00/png?font=pt%20sans&text=.png%0APt%20Sans
/// https://placehold.co/300x100/000000/00FF00/png?font=raleway&text=.png%0ARaleway
/// https://placehold.co/300x100/000000/00FF00/png?font=roboto&text=.png%0ARoboto
/// https://placehold.co/300x100/000000/00FF00/png?font=source%20sans%20pro&text=.png%0ASource%20Sans%20Pro
/// https://placehold.co/300x100/000000/00FF00/svg?font=lato&text=.svg%0ALato
/// https://placehold.co/300x100/000000/00FF00/svg?font=lora&text=.svg%0ALora
/// https://placehold.co/300x100/000000/00FF00/svg?font=montserrat&text=.svg%0AMontserrat
/// https://placehold.co/300x100/000000/00FF00/svg?font=open%20sans&text=.svg%0AOpen%20Sans
/// https://placehold.co/300x100/000000/00FF00/svg?font=oswald&text=.svg%0AOswald
/// https://placehold.co/300x100/000000/00FF00/svg?font=playfair%20display&text=.svg%0APlayfair%20Display
/// https://placehold.co/300x100/000000/00FF00/svg?font=pt%20sans&text=.svg%0APt%20Sans
/// https://placehold.co/300x100/000000/00FF00/svg?font=raleway&text=.svg%0ARaleway
/// https://placehold.co/300x100/000000/00FF00/svg?font=roboto&text=.svg%0ARoboto
/// https://placehold.co/300x100/000000/00FF00/svg?font=source%20sans%20pro&text=.svg%0ASource%20Sans%20Pro
/// https://placehold.co/300x100/000000/00FF00/webp?font=lato&text=.webp%0ALato
/// https://placehold.co/300x100/000000/00FF00/webp?font=lora&text=.webp%0ALora
/// https://placehold.co/300x100/000000/00FF00/webp?font=montserrat&text=.webp%0AMontserrat
/// https://placehold.co/300x100/000000/00FF00/webp?font=open%20sans&text=.webp%0AOpen%20Sans
/// https://placehold.co/300x100/000000/00FF00/webp?font=oswald&text=.webp%0AOswald
/// https://placehold.co/300x100/000000/00FF00/webp?font=playfair%20display&text=.webp%0APlayfair%20Display
/// https://placehold.co/300x100/000000/00FF00/webp?font=pt%20sans&text=.webp%0APt%20Sans
/// https://placehold.co/300x100/000000/00FF00/webp?font=raleway&text=.webp%0ARaleway
/// https://placehold.co/300x100/000000/00FF00/webp?font=roboto&text=.webp%0ARoboto
/// https://placehold.co/300x100/000000/00FF00/webp?font=source%20sans%20pro&text=.webp%0ASource%20Sans%20Pro/// ```
///

