//
//  AVAuthorizationStatus+Helpers.swift
//  FileVault
//
//  Created by Zakk Hoyt on 2024-10-06.
//

import AVFoundation

extension AVAuthorizationStatus: @retroactive CustomStringConvertible {
    
    public var description: String {
        switch self {
        case .notDetermined: "notDetermined"
        case .restricted: "restricted"
        case .denied: "denied"
        case .authorized: "authorized"
        @unknown default: "@unknown default"
        }
    }
}

