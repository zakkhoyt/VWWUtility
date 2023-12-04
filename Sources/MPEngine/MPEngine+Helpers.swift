//
//  MPEngine+Helpers.swift
//
//
//  Created by Zakk Hoyt on 12/2/23.
//

import Foundation
import MultipeerConnectivity

extension MCSessionState: CustomStringConvertible {
    public var description: String {
        switch self {
        case .notConnected: ".notConnected"
        case .connecting: ".connecting"
        case .connected: ".connected"
        @unknown default: "@unknown default"
        }
    }
}

#warning("TODO: zakkhoyt - See what the default is")
extension MCPeerID: CustomStringConvertible {
    override open var description: String {
        displayName
    }
}
