//
//  AppIcon+Device.swift
//
//  Created by Zakk Hoyt on 10/22/21.
//

#if os(macOS)

import AppKit
import Foundation

extension AppIcon {
    // TODO: Rename to Idiom
    
    public enum Device: String, Codable, CaseIterable {
        case iOS = "ios"
        case macOS = "mac"
        case watchOS = "watch"

        // Outputs dates appIcon sets
        case iPad_xcode13 = "ipad_xcode13"
        case iPhone_xcode13 = "iphone_xcode13"
        case watch_xcode13

        // case car = "car"
        // case universal
        // case tv
        
        public var icons: [Icon] {
            switch self {
            case .iOS:
                [
                    Icon(scale: 2, square: 20, idiom: .universal, platform: .iOS),
                    Icon(scale: 3, square: 20, idiom: .universal, platform: .iOS),
                    Icon(scale: 2, square: 29, idiom: .universal, platform: .iOS),
                    Icon(scale: 3, square: 29, idiom: .universal, platform: .iOS),
                    Icon(scale: 2, square: 38, idiom: .universal, platform: .iOS),
                    Icon(scale: 3, square: 38, idiom: .universal, platform: .iOS),
                    Icon(scale: 2, square: 40, idiom: .universal, platform: .iOS),
                    Icon(scale: 3, square: 40, idiom: .universal, platform: .iOS),
                    Icon(scale: 2, square: 60, idiom: .universal, platform: .iOS),
                    Icon(scale: 3, square: 60, idiom: .universal, platform: .iOS),
                    Icon(scale: 2, square: 64, idiom: .universal, platform: .iOS),
                    Icon(scale: 3, square: 64, idiom: .universal, platform: .iOS),

                    Icon(scale: 2, square: 68, idiom: .universal, platform: .iOS),
                    Icon(scale: 2, square: 76, idiom: .universal, platform: .iOS),
                    Icon(scale: 2, square: 83.5, idiom: .universal, platform: .iOS),
                    Icon(scale: 1, square: 1024, idiom: .universal, platform: .iOS /* , format: .jpg */ )
                ]
            case .macOS:
                [
                    Icon(scale: 1, square: 16, idiom: .mac),
                    Icon(scale: 2, square: 16, idiom: .mac),
                    Icon(scale: 1, square: 32, idiom: .mac),
                    Icon(scale: 2, square: 32, idiom: .mac),
                    Icon(scale: 1, square: 128, idiom: .mac),
                    Icon(scale: 2, square: 128, idiom: .mac),
                    Icon(scale: 1, square: 256, idiom: .mac),
                    Icon(scale: 2, square: 256, idiom: .mac),
                    Icon(scale: 1, square: 512, idiom: .mac),
                    Icon(scale: 2, square: 512, idiom: .mac)
                    // Icon(scale: 1, square: 1024, idiom: .mac/*, format: .jpg*/)
                ]
            case .watchOS:
                [
                    Icon(scale: 2, square: 22, idiom: .universal, platform: .watchOS),
                    Icon(scale: 2, square: 24, idiom: .universal, platform: .watchOS),
                    Icon(scale: 2, square: 27.5, idiom: .universal, platform: .watchOS),
                    Icon(scale: 2, square: 29, idiom: .universal, platform: .watchOS),
                    Icon(scale: 2, square: 30, idiom: .universal, platform: .watchOS),

                    Icon(scale: 2, square: 32, idiom: .universal, platform: .watchOS),
                    Icon(scale: 2, square: 33, idiom: .universal, platform: .watchOS),
                    Icon(scale: 2, square: 40, idiom: .universal, platform: .watchOS),
                    Icon(scale: 2, square: 43.5, idiom: .universal, platform: .watchOS),
                    Icon(scale: 2, square: 44, idiom: .universal, platform: .watchOS),

                    Icon(scale: 2, square: 46, idiom: .universal, platform: .watchOS),
                    Icon(scale: 2, square: 50, idiom: .universal, platform: .watchOS),
                    Icon(scale: 2, square: 51, idiom: .universal, platform: .watchOS),
                    Icon(scale: 2, square: 54, idiom: .universal, platform: .watchOS),
                    Icon(scale: 2, square: 86, idiom: .universal, platform: .watchOS),

                    Icon(scale: 2, square: 98, idiom: .universal, platform: .watchOS),
                    Icon(scale: 2, square: 108, idiom: .universal, platform: .watchOS),
                    Icon(scale: 2, square: 117, idiom: .universal, platform: .watchOS),
                    Icon(scale: 2, square: 129, idiom: .universal, platform: .watchOS)
                ]
            case .iPhone_xcode13:
                [
                    Icon(scale: 2, square: 20, idiom: .iPhone),
                    Icon(scale: 3, square: 20, idiom: .iPhone),
                    Icon(scale: 2, square: 29, idiom: .iPhone),
                    Icon(scale: 3, square: 29, idiom: .iPhone),
                    Icon(scale: 2, square: 40, idiom: .iPhone),
                    Icon(scale: 3, square: 40, idiom: .iPhone),
                    Icon(scale: 2, square: 60, idiom: .iPhone),
                    Icon(scale: 3, square: 60, idiom: .iPhone),
                    Icon(scale: 1, square: 1024, idiom: .iOSMarketing /* , format: .jpg */ )
                ]
            case .iPad_xcode13:
                [
                    Icon(scale: 1, square: 20, idiom: .iPad),
                    Icon(scale: 2, square: 20, idiom: .iPad),
                    Icon(scale: 1, square: 29, idiom: .iPad),
                    Icon(scale: 2, square: 29, idiom: .iPad),
                    Icon(scale: 1, square: 40, idiom: .iPad),
                    Icon(scale: 2, square: 40, idiom: .iPad),
                    Icon(scale: 1, square: 76, idiom: .iPad),
                    Icon(scale: 2, square: 76, idiom: .iPad),
                    Icon(scale: 2, square: 83.5, idiom: .iPad),
                    Icon(scale: 1, square: 1024, idiom: .iOSMarketing /* , format: .jpg*/ )
                ]
            case .watch_xcode13:
                [
                    Icon(scale: 2, square: 48, idiom: .watch),
                    Icon(scale: 2, square: 55, idiom: .watch),
                    Icon(scale: 2, square: 66, idiom: .watch),
                    Icon(scale: 2, square: 58, idiom: .watch),
                    Icon(scale: 2, square: 80, idiom: .watch),
                    Icon(scale: 2, square: 87, idiom: .watch),
                    Icon(scale: 2, square: 88, idiom: .watch),
                    Icon(scale: 2, square: 92, idiom: .watch),
                    Icon(scale: 2, square: 100, idiom: .watch),
                    Icon(scale: 2, square: 102, idiom: .watch),
                    Icon(scale: 2, square: 172, idiom: .watch),
                    Icon(scale: 2, square: 196, idiom: .watch),
                    Icon(scale: 2, square: 216, idiom: .watch),
                    Icon(scale: 2, square: 234, idiom: .watch),
                    Icon(scale: 1, square: 1024, idiom: .watch /* , format: .jpg */ )
                ]
                // case .car:
                //     return [
                //         Icon(scale: 1, square: 60, idiom: .car),
                //         Icon(scale: 2, square: 60, idiom: .car)
                //     ]
                // case .universal:
                //     // TODO: populate
                //     return []
                // case .tv:
                //     // TODO: populate
                //     return []
            }
        }
    }
}

#endif
