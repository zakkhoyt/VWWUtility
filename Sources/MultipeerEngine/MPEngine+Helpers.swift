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

extension [MCPeerID] {
    var peers: [MPEngine.Peer] {
        map { MPEngine.Peer(peerID: $0) }
    }
}

extension [MPEngine.Peer] {
    var peerIDs: [MCPeerID] {
        map { MCPeerID(displayName: $0.name) }
    }
}
