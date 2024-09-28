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
                ].listDescription()
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
        
        public actor DataStore {
            @Published
            public private(set) var state = State.stopped

            func setState(_ newState: State) {
                state = newState
            }

            @Published
            public private(set) var advertisedServices = [Service]()

            func removeAllAdvertisedServices() {
                advertisedServices.removeAll()
            }
            
            func appendAdvertisedService(_ service: Service) {
                advertisedServices.append(service)
            }
            
            func refreshAdvertisedServices() {
                advertisedServices = advertisedServices
            }
        }

        // MARK: Public properties

//        @Published
//        public private(set) var state = State.stopped
//
//        @Published
//        public private(set) var advertisedServices = [Service]()
        
        public let dataStore = DataStore()
        
        // MARK: Internal vars
        
        var serviceType: String {
            serviceBrowser.serviceType
        }
        
        // MARK: Private vars

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
            
            Task {
                await dataStore.setState(.started)
            }

            logger.debug(
                """
                \(#function, privacy: .public):#\(#line) - \
                peerID: \(self.serviceBrowser.myPeerID.displayName, privacy: .public) \
                serviceName: \(self.serviceBrowser.serviceType, privacy: .public)
                """
            )
        }
        
        func stopBrowsing() {
            serviceBrowser.delegate = nil
            serviceBrowser.stopBrowsingForPeers()
            
            Task {
                await dataStore.removeAllAdvertisedServices()
                await dataStore.setState(.stopped)
            }
            
            logger.debug(
                """
                \(#function, privacy: .public):#\(#line)
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
            Task {
//                advertisedServices = advertisedServices
                await dataStore.refreshAdvertisedServices()
            }
            
            logger.debug(
                """
                \(#function, privacy: .public):#\(#line) - \
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
            Task {
                guard let service = await dataStore.advertisedServices.first(where: {
                    $0.peerID == peerID
                }) else {
                    logger.error(
                        """
                        \(#function, privacy: .public):#\(#line) - \
                        Failed to find service with peerID: \(peerID.displayName)
                        state: \(state, privacy: .public)
                        """
                    )
                    return
                }
                
                switch state {
                case .notConnected:
                    service.invitationState = .invitationRejected(.now)
                    await dataStore.refreshAdvertisedServices()
                case .connecting:
                    break
                case .connected:
                    service.invitationState = .invitationAccepted(.now)
                    await dataStore.refreshAdvertisedServices()
                @unknown default:
                    break
                }
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
        Task {
//            advertisedServices.append(
            await dataStore.appendAdvertisedService(
                Service(
                    peerID: peerID,
                    discoveryInfo: info
                )
            )
            
            logger.debug(
                """
                \(#function, privacy: .public):#\(#line) - \
                peerID: \(peerID.displayName, privacy: .public) \
                info: \(info?.description ?? "<nil>", privacy: .public)
                """
            )
        }
    }

    // A nearby peer has stopped advertising.
    public func browser(
        _ browser: MCNearbyServiceBrowser,
        lostPeer peerID: MCPeerID
    ) {
        logger.debug(
            """
            \(#function, privacy: .public):#\(#line) - \
            peerID: \(peerID.displayName, privacy: .public)
            """
        )
    }

    // Browsing did not start due to an error.
    public func browser(
        _ browser: MCNearbyServiceBrowser,
        didNotStartBrowsingForPeers error: any Error
    ) {
        Task {
//            state = .failed(error)
            await dataStore.setState(.failed(error))
            logger.fault(
                """
                \(#function, privacy: .public):#\(#line) - \
                error: \(error.localizedDescription, privacy: .public)
                """
            )
        }
    }
}
