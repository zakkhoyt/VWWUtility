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
    public final class Advertiser: NSObject {
        // MARK: Nested Types
        
        public enum State {
            case stopped
            case started
            case failed(any Error)
        }

        public class Invititation: Hashable, Identifiable, CustomStringConvertible {
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
//                #warning("TODO: zakkhoyt - VWWUtil, list to description or, reflection, etc..")
//                var valueStrings = [
//                    "id: \(id.uuidString)",
//                    "peerID: \(peerID.displayName)"
//                ]
//
//                #warning("TODO: zakkhoyt - data to string")
//                if let context {
//                    if let contextText = String(data: context, encoding: .utf8) {
//                        valueStrings.append("context: \(contextText)")
//                    } else {
//                        valueStrings.append("context: \(context.count) bytes")
//                    }
//                }
//
//                return valueStrings.joined(separator: ", ")

//                OrderedDictionary<String, String>(
//                    [
//                        "id": id.uuidString,
//                        "peerID": peerID.displayName,
//                        "context": {
//                            guard let context else { return nil }
//                            if let contextText = String(data: context, encoding: .utf8) {
//                                return contextText
//                            } else {
//                                return "\(context.count) bytes"
//                            }
//                        }()
//                    ].compactMapValues { $0 }
//                ).map {
//                    [
//                        $0.key, $0.value
//                    ].joined(separator: ": ")
//                }.joined(separator: ", ")

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
                ].varDescription
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

        // MARK: Public properties
        
        public let state = CurrentValueSubject<State, Never>(.stopped)
        
        public let invitations = CurrentValueSubject<[Invititation], Never>([])

        private var advertisedServiceName: String?
        private var serviceAdvertiser = MCNearbyServiceAdvertiser(
            peer: MCPeerID(displayName: "com.tempPID"),
            discoveryInfo: nil,
            serviceType: "abc-temp"
        )

        // MARK: Internal Inits
        
        init(
            peerID: MCPeerID,
            serviceType: String,
            discoveryInfo: [String: String] = [:]
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
            state.value = .started
            
            logger.debug(
                """
                [DEBUG] \(#function, privacy: .public):#\(#line) - \
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
            invitations.value.removeAll()
            state.value = .stopped
            
            logger.debug(
                """
                [DEBUG] \(#function, privacy: .public):#\(#line)
                """
            )
        }

        func respond(
            invitation: Advertiser.Invititation,
            accept: Bool,
            session: MCSession
        ) {
            invitation.handler(accept, session)

//            invitations.removeAll {
//                $0.id == invitation.id
//            }
            
            invitation.response = accept ? .accepted(.now) : .rejected(.now)
            invitations.send(invitations.value)
            
            logger.debug(
                """
                [DEBUG] \(#function, privacy: .public):#\(#line) - \
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
        state.value = .failed(error)
        
        logger.fault(
            """
            [FAULT] \(#function, privacy: .public):#\(#line) - \
            error: \(error.localizedDescription, privacy: .public)
            """
        )
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

        invitations.value.append(
            Invititation(
                peerID: peerID,
                context: context,
                handler: invitationHandler
            )
        )

//        DispatchQueue.main.async {
//            self.invitations.value.append(
//                Invititation(
//                    peerID: peerID,
//                    context: context,
//                    handler: invitationHandler
//                )
//            )
//        }
        
        logger.debug(
            """
            [DEBUG] \(#function, privacy: .public):#\(#line) - \
            didReceiveInvitationFromPeer: \(peerID.displayName, privacy: .public) \
            context: \(contextDescription) \
            invitationHandler: [redacted]
            """
        )
    }
}
