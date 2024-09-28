//
//  MPEngine+Advertiser.swift
//
//
//  Created by Zakk Hoyt on 12/2/23.
//

import BaseUtility
import Collections
import Combine
import Foundation
import MultipeerConnectivity

extension MPEngine {
    public final class Advertiser: NSObject, Sendable {
        // MARK: Nested Types
        
        public enum DiscoveryInfo: Sendable {
            public static let activityKey = "activity"
            public static let messageKey = "message"
        }
        
        public enum State: Sendable {
            case stopped
            case started
            case failed(any Error)
        }
        
        public final class Invititation: Sendable, Hashable, Identifiable, CustomStringConvertible {
            // public enum Response: Hashable, Identifiable, CustomStringConvertible {
            public enum Response: CustomStringConvertible {
                case noResponse
                case accepted(Date)
                case rejected(Date)
                
                public var description: String {
                    switch self {
                    case .noResponse: ".noResponse"
                    case .accepted(let date): ".accepted \(date.string(formatProvider: DateFormat.accurate))"
                    case .rejected(let date): ".rejected \(date.string(formatProvider: DateFormat.accurate))"
                    }
                }
            }
            
            public let id = UUID()
            public let peerID: MCPeerID
            public let context: Data?
            public let handler: (Bool, MCSession?) -> Void
            public var response: Response = .noResponse
            
            public var description: String {
                [
                    "id": id.uuidString,
                    "peerID": peerID.displayName,
                    "context": {
                        guard let context else { return nil }
                        if let contextText = String(data: context, encoding: .utf8) {
                            return contextText
                        } else {
                            return "\(context.count) bytes"
                        }
                    }(),
                    "response": response.description
                ]
                    .compactMapValues { $0 }
                    .listDescription()
            }
            
            public static func == (
                lhs: MPEngine.Advertiser.Invititation,
                rhs: MPEngine.Advertiser.Invititation
            ) -> Bool {
                lhs.id == rhs.id
            }
            
            public func hash(into hasher: inout Hasher) {
                hasher.combine(id)
            }
            
            // MARK: Internal inits
            
            init(
                peerID: MCPeerID,
                context: Data?,
                handler: @escaping (Bool, MCSession?) -> Void
            ) {
                self.peerID = peerID
                self.context = context
                self.handler = handler
            }
        }
        
        public actor DataStore {
            @Published
            public private(set) var state: State = .stopped
            
            func setState(_ newState: State) {
                state = newState
            }
            
            @Published
            public private(set) var invitations: [Invititation] = []
            
            func removeAllInvitations() {
                invitations.removeAll()
            }
            
            func appendInvitation(_ invitation: Invititation) {
                invitations.append(invitation)
            }
            
            func refreshInvitations() {
                invitations = invitations
            }
        }
        
        // MARK: Public properties
        
        public let dataStore = DataStore()
        
        // MARK: Internal properties
        
        var peerID: MCPeerID {
            serviceAdvertiser.myPeerID
        }
        
        var serviceType: String {
            serviceAdvertiser.serviceType
        }
        
        var discoveryInfo: [String: String]? {
            serviceAdvertiser.discoveryInfo
        }
        
        // MARK: Private vars
        
        private var serviceAdvertiser = MCNearbyServiceAdvertiser(
            peer: MCPeerID(displayName: "com.tempPID"),
            discoveryInfo: nil,
            serviceType: "abc-temp"
        )

        // MARK: Internal Inits
        
        init(
            peerID: MCPeerID,
            serviceType: String,
            discoveryInfo: [String: String]?
        ) {
            self.serviceAdvertiser = MCNearbyServiceAdvertiser(
                peer: peerID,
                discoveryInfo: discoveryInfo,
                serviceType: serviceType
            )

            super.init()
        }

        // MARK: Internal functions
        
        func startAdvertising() {
            // stop (clean up)
            stopAdvertising()
            
            // start
            serviceAdvertiser.delegate = self
            serviceAdvertiser.startAdvertisingPeer()
            
            Task {
                await dataStore.setState(.started)
            }
            
            logger.debug(
                """
                \(#function, privacy: .public):#\(#line) - \
                Did start advertising \
                peerID: \(self.serviceAdvertiser.myPeerID.displayName, privacy: .public) \
                discoveryInfo: \(self.serviceAdvertiser.discoveryInfo ?? [:], privacy: .public) \
                serviceName: \(self.serviceAdvertiser.serviceType, privacy: .public)
                """
            )
        }
        
        func stopAdvertising() {
            serviceAdvertiser.delegate = nil
            serviceAdvertiser.stopAdvertisingPeer()

            Task {
                await dataStore.removeAllInvitations()
                await dataStore.setState(.stopped)
            }
            
            logger.debug(
                """
                \(#function, privacy: .public):#\(#line)
                """
            )
        }

        func respond(
            invitation: Advertiser.Invititation,
            accept: Bool,
            session: MCSession
        ) {
            invitation.handler(accept, session)

            invitation.response = accept ? .accepted(.now) : .rejected(.now)

            Task {
                await dataStore.refreshInvitations()
            }
            
            logger.debug(
                """
                \(#function, privacy: .public):#\(#line) - \
                accept: \(accept, privacy: .public) \
                invitation: \(invitation, privacy: .public)
                """
            )
        }
    }
}

extension MPEngine.Advertiser: MCNearbyServiceAdvertiserDelegate {
    // Advertising did not start due to an error.
    public func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didNotStartAdvertisingPeer error: any Error
    ) {
        Task {
//            dataStore.state = .failed(error)
            await dataStore.setState(.failed(error))
            
            logger.fault(
                """
                \(#function, privacy: .public):#\(#line) - \
                error: \(error.localizedDescription, privacy: .public)
                """
            )
        }
    }

    // Incoming invitation request.  Call the invitationHandler block with YES
    // and a valid session to connect the inviting peer to the session.
    public func advertiser(
        _ advertiser: MCNearbyServiceAdvertiser,
        didReceiveInvitationFromPeer peerID: MCPeerID,
        withContext context: Data?,
        invitationHandler: @escaping (Bool, MCSession?) -> Void
    ) {
        let contextDescription = if let context {
            "\(context.count)"
        } else {
            "<nil>"
        }

        Task {
            await dataStore.appendInvitation(
                Invititation(
                    peerID: peerID,
                    context: context,
                    handler: invitationHandler
                )
            )
        }
        
        logger.debug(
            """
            \(#function, privacy: .public):#\(#line) - \
            didReceiveInvitationFromPeer: \(peerID.displayName, privacy: .public) \
            context: \(contextDescription) \
            invitationHandler: [redacted]
            """
        )
    }
}
