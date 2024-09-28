//
//  AppIcon+Writer.swift
//
//  Created by Zakk Hoyt on 10/22/21.
//

#if os(macOS)

import Foundation
import BaseUtility

extension AppIcon {
    public enum Writer {
        public enum Error: Swift.Error {
            case noValidOutputDestination
        }
        
        typealias AppIconResult = (URL, AppIcon.Contents.Icon)
        
        static func makeOutputFileUrl(
            icon: AppIcon.Icon,
            from inputFileUrl: URL,
            to outputDirectoryUrl: URL
        ) -> URL {
            let sizeSuffix: String = {
                let widthSuffix = icon.size.width.precisionString(mantissaCount: 1)
                let heightSuffix = icon.size.height.precisionString(mantissaCount: 1)
                return "\(widthSuffix)x\(heightSuffix)"
            }()
            
            // If scale > 1, convert to '@2x', '@3x', etc...
            let scaleSuffix = icon.scale == 1 ? "" : "@\(Int(icon.scale))x"
            
            //            // If a file already exists at the proposed output url, start appending '-1', '-2', etc...
            //            let countSuffix: String = i == 0 ? "" : "-\(i)"
            
            //            // Moosh all the suffix parts together
            //            let suffix = "_\(sizeSuffix)\(scaleSuffix)\(countSuffix)"
            
            // Moosh all the suffix parts together
            let suffix = "_\(sizeSuffix)\(scaleSuffix)"
            let outputFileName = "\(inputFileUrl.deletingPathExtension().lastPathComponent)\(suffix)"
            let outputFileUrl = outputDirectoryUrl
                .appendingPathComponent(outputFileName)
                .appendingPathExtension(icon.format.rawValue)
            
            return outputFileUrl
        }
        
        static func nextNumberedUrl(
            url: URL
        ) throws -> URL {
            for i in 0..<100 {
                let proposedUrl: URL = {
                    // If a file already exists at the proposed output url, start appending '-1', '-2', etc...
                    let countSuffix: String = i == 0 ? "" : "-\(i)"
                    
                    return url.deletingLastPathComponent()
                        .appendingPathComponent("\(url.deletingPathExtension().lastPathComponent)\(countSuffix)")
                        .appendingPathExtension(url.pathExtension)
                }()
                
                if !FileService.fileExists(url: proposedUrl) {
                    return proposedUrl
                } else {
                    //                    logger.debug("File exists at \(proposedUrl.path)")
                }
            }
            throw Error.noValidOutputDestination
        }
        
        public static func createImages(
            device: AppIcon.Device,
            from inputFileUrl: URL,
            to outputDirectoryUrl: URL
        ) throws -> [URL] {
            try device.icons.map { icon in
                try createImage(
                    icon: icon,
                    from: inputFileUrl,
                    to: outputDirectoryUrl
                )
            }
        }
        
        /// Creates a resized image based off of the input.
        /// - Parameters:
        ///   - icon: The properties of the resized image
        ///   - inputFileUrl: The source image to resize.
        ///   - outputDirectoryUrl: The directory where we should write a copy
        ///   - copyIfImageExists: Defaults to `false`. When set to `true`, create a numbered copy of the image.
        ///   For example if we need ot resize to `image.png` and that file already exists, try `image-1.png` and so on until we find a unique name.
        /// - Returns: The `URL` of the image.
        public static func createImage(
            icon: AppIcon.Icon,
            from inputFileUrl: URL,
            to outputDirectoryUrl: URL,
            copyIfImageExists: Bool = false
        ) throws -> URL {
            let outputFileUrl: URL = try {
                let proposedUrl: URL = makeOutputFileUrl(
                    icon: icon,
                    from: inputFileUrl,
                    to: outputDirectoryUrl
                )
                
                if copyIfImageExists {
                    return try nextNumberedUrl(url: proposedUrl)
                } else {
                    return proposedUrl
                }
            }()
            
            if FileService.fileExists(url: outputFileUrl) {
                // No need to render a second image
                return outputFileUrl
            }
            
            let url = try Sips.resizeImage(
                at: inputFileUrl,
                size: CGSize(width: icon.scale * icon.size.width, height: icon.scale * icon.size.height),
                format: icon.format.rawValue,
                outputFileUrl: outputFileUrl
            )
            return url
        }
        
        public static func createIconContent(
            url: URL,
            device: AppIcon.Device,
            icon: AppIcon.Icon
        ) -> AppIcon.Contents.Icon {
            AppIcon.Contents.Icon(
                fileName: url.lastPathComponent,
                idiom: icon.idiom,
                platform: icon.platform,
                scale: icon.scale,
                size: icon.size,
                appearances: icon.appearances
            )
        }
        
        public static func createAppIconSet(
            for devices: [AppIcon.Device],
            from inputFileUrl: URL,
            outputDirectoryUrl: URL
        ) throws -> URL {
            // Make sure dir exists
            try FileService.createDirectory(url: outputDirectoryUrl)
            
            // TODO: Read existing perhaps? Increment version?
            let info = Contents.Info(
                author: "Hatch",
                version: 1
            )
            var icons: [AppIcon.Contents.Icon] = []
            
            try devices.forEach { device in
                let tuples = try createAppIconSet(
                    for: device,
                    from: inputFileUrl,
                    to: outputDirectoryUrl
                )
                
                // TODO: Remove duplicates either before or after. Ex; Both iPhone and iPad have a 1024 ios_marketing image, but we only need 1
                
                tuples.forEach {
                    //                    let iconUrl = $0.0
                    let deviceIcon = $0.1
                    
                    // TODO: xcode tends to copy duplicate images and appends "-1" to the file name.
                    //                    // Copy image file into *.appIconSet/ folder
                    //                    let proposedUrl = outputDirectoryUrl
                    //                        .appendingPathComponent(iconUrl.lastPathComponent)
                    //                    let destinationUrl = try nextNumberedUrl(url: proposedUrl)
                    //
                    //                    logger.debug(category: "copy", "Copy file from \(iconUrl) to \(destinationUrl.path)")
                    //                    try FileService.copyFile(source: iconUrl, dest: destinationUrl)
                    
                    //                    logger.debug(category: "json", "appending icon image \(deviceIcon.fileName)")
                    icons.append(deviceIcon)
                }
            }
            
            // Write jston file
            let contents = AppIcon.Contents(
                info: info,
                images: icons
            )
            
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(contents)
            try data.write(to: outputDirectoryUrl.appendingPathComponent("Contents").appendingPathExtension("json"))
            return outputDirectoryUrl
        }
        
        private static func createAppIconSet(
            for device: AppIcon.Device,
            from inputFileUrl: URL,
            to outputDirectoryUrl: URL
        ) throws -> [AppIconResult] {
            try device.icons.map { icon in
                let url = try createImage(
                    icon: icon,
                    from: inputFileUrl,
                    to: outputDirectoryUrl,
                    copyIfImageExists: true
                )
                
                // TODO: xcode tends to copy duplicate images and appends "-1" to the file name.
                
                let outputIcon = createIconContent(
                    url: url,
                    device: device,
                    icon: icon
                )
                return (url, outputIcon)
            }
        }
    }
}

#endif
