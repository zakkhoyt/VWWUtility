//
//  MPEngine+Browser.swift
//
//
//  Created by Zakk Hoyt on 12/2/23.
//

import Combine
import Foundation
import MultipeerConnectivity

extension MPEngine {
    public final class Browser: NSObject {
        // MARK: Nested Types

        public enum State {
            case stopped
            case started
            case failed(any Error)
        }

//        #warning("FIXME: zakkhoyt - Represent state (waiting for response)")
        
        public final class Service: Hashable, Identifiable, CustomStringConvertible {
            // MARK: Nested Types
  
            /// Represents the state of a discovered service
            public enum InvitationState: Hashable, Identifiable, CustomStringConvertible {
                case notSent // initial state
                case invitationSent(Date) // when user sends invite
                case invitationAccepted(Date)
                case invitationRejected(Date)
                case invitationTimedOut(Date)

                public var id: Int {
                    switch self {
                    case .notSent: 1
                    case .invitationSent: 2
                    case .invitationAccepted: 3
                    case .invitationRejected: 4
                    case .invitationTimedOut: 5
                    }
                }
                
                public var description: String {
                    switch self {
                    case .notSent: ".notSent"
                    case .invitationSent: ".invitationSent"
                    case .invitationAccepted: ".invitationAccepted"
                    case .invitationRejected: ".invitationRejected"
                    case .invitationTimedOut: ".invitationTimedOut"
                    }
                }
            }
            
            public let id = UUID()
            public let peerID: MCPeerID
            public let discoveryInfo: [String: String]?
            public var invitationState: InvitationState = .notSent

            public var description: String {
                [
                    "peerID": peerID.displayName,
                    "id": id.uuidString,
                    "discoveryInfo": discoveryInfo?.description
                ].varDescription
            }
            
            public static func == (
                lhs: MPEngine.Browser.Service,
                rhs: MPEngine.Browser.Service
            ) -> Bool {
                lhs.id == rhs.id
            }
            
            public func hash(into hasher: inout Hasher) {
                hasher.combine(id)
                hasher.combine(invitationState)
            }
            
            // MARK: Internal inits
            
            init(
                peerID: MCPeerID,
                discoveryInfo: [String: String]?
            ) {
                self.peerID = peerID
                self.discoveryInfo = discoveryInfo
            }
        }

        // MARK: Public properties

        public let state = CurrentValueSubject<State, Never>(.stopped)

        public let advertisedServices = CurrentValueSubject<[Service], Never>([])

        private let serviceBrowser: MCNearbyServiceBrowser

        init(
            peerID: MCPeerID,
            serviceType: String
        ) {
            self.serviceBrowser = MCNearbyServiceBrowser(
                peer: peerID,
                serviceType: serviceType
            )
            super.init()
        }
        
        func startBrowsing() {
            // stop (clean up)
            stopBrowsing()
            
            // start
            serviceBrowser.delegate = self
            serviceBrowser.startBrowsingForPeers()
            state.value = .started

            logger.debug(
                """
                [DEBUG] \(#function, privacy: .public):#\(#line) - \
                peerID: \(self.serviceBrowser.myPeerID.displayName, privacy: .public) \
                serviceName: \(self.serviceBrowser.serviceType, privacy: .public)
                """
            )
        }
        
        func stopBrowsing() {
            serviceBrowser.delegate = nil
            serviceBrowser.stopBrowsingForPeers()
            advertisedServices.value.removeAll()
            state.value = .stopped
            
            logger.debug(
                """
                [DEBUG] \(#function, privacy: .public):#\(#line)
                """
            )
        }
        
        func invite(
            service: MPEngine.Browser.Service,
            session: MCSession,
            context: Data? = nil,
            timeout: TimeInterval = 10
        ) {
            serviceBrowser.invitePeer(
                service.peerID,
                to: session,
                withContext: context,
                timeout: timeout
            )
            
            service.invitationState = .invitationSent(.now)
            advertisedServices.send(advertisedServices.value)
            
            logger.debug(
                """
                [DEBUG] \(#function, privacy: .public):#\(#line) - \
                peerID: \(service.peerID.displayName, privacy: .public) \
                session: \(self.serviceBrowser.serviceType, privacy: .public)
                """
            )
        }
        
        func session(
            _ session: MCSession,
            peer peerID: MCPeerID,
            didChange state: MCSessionState
        ) {
            guard let service = advertisedServices.value.first(where: {
                $0.peerID == peerID
            }) else {
                logger.error(
                    """
                    [ERROR] \(#function, privacy: .public):#\(#line) - \
                    Failed to find service with peerID: \(peerID.displayName)
                    state: \(state, privacy: .public)
                    """
                )
                return
            }
            
            switch state {
            case .notConnected:
                service.invitationState = .invitationRejected(.now)
                advertisedServices.send(advertisedServices.value)
            case .connecting:
                break
            case .connected:
                service.invitationState = .invitationAccepted(.now)
                advertisedServices.send(advertisedServices.value)
            @unknown default:
                break
            }
        }
    }
}

extension MPEngine.Browser: MCNearbyServiceBrowserDelegate {
    // Found a nearby advertising peer.
    public func browser(
        _ browser: MCNearbyServiceBrowser,
        foundPeer peerID: MCPeerID,
        withDiscoveryInfo info: [String: String]?
    ) {
        advertisedServices.value.append(
            Service(
                peerID: peerID,
                discoveryInfo: info
            )
        )
        
        logger.debug(
            """
            [DEBUG] \(#function, privacy: .public):#\(#line) - \
            peerID: \(peerID.displayName, privacy: .public) \
            info: \(info?.description ?? "<nil>", privacy: .public)
            """
        )
    }

    // A nearby peer has stopped advertising.
    public func browser(
        _ browser: MCNearbyServiceBrowser,
        lostPeer peerID: MCPeerID
    ) {
        logger.debug(
            """
            [DEBUG] \(#function, privacy: .public):#\(#line) - \
            peerID: \(peerID.displayName, privacy: .public)
            """
        )
    }

    // Browsing did not start due to an error.
    public func browser(
        _ browser: MCNearbyServiceBrowser,
        didNotStartBrowsingForPeers error: any Error
    ) {
        state.value = .failed(error)
        logger.fault(
            """
            [FAULT] \(#function, privacy: .public):#\(#line) - \
            error: \(error.localizedDescription, privacy: .public)
            """
        )
    }
}