//
//  MPEngine.swift
//
//  Created by Zakk Hoyt on 12/2/23.
//

// https://www.hackingwithswift.com/example-code/networking/how-to-create-a-peer-to-peer-network-using-the-multipeer-connectivity-framework
// https://www.kodeco.com/12689804-getting-started-with-multipeer-connectivity
// https://www.kodeco.com/books/modern-concurrency-in-swift/v2.0/chapters/10-actors-in-a-distributed-system

import BaseUtility
import Collections
import Combine
import Foundation
import MultipeerConnectivity

public protocol PayloadRepresentable: Identifiable, Hashable {
    var id: UUID { get }
    var connectedPeer: MPEngine.Peer { get }
    var text: String { get }
    var date: Date { get }
}

public final class MPEngine: NSObject, Sendable {
    public enum Encryption: @unchecked Sendable {
        /// Session prefers encryption but will accept unencrypted connections.
        case optional
        
        /// Session requires encryption
        case required

        /// Session should not be encrypted
        case unencrypted
        
        fileprivate var mcEncryptionPreference: MCEncryptionPreference {
            switch self {
            case .optional: .optional
            case .required: .required
            case .unencrypted: .none
            }
        }
    }

    public struct Peer: Sendable, Identifiable, Hashable, CustomStringConvertible, Codable {
        public var id: String { name }
        public let name: String
        
        public var description: String {
            [
                "id": id,
                "name": name
            ].varDescription
        }
        
        public static func == (
            lhs: MPEngine.Peer,
            rhs: MPEngine.Peer
        ) -> Bool {
            lhs.id == rhs.id
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        init(peerID: MCPeerID) {
            self.name = peerID.displayName
        }
    }
    
    public final class Payload: PayloadRepresentable, Identifiable, Hashable, Sendable {
        public let id = UUID()
        public let connectedPeer: Peer
        public let text: String
        public let date: Date
        
        public var description: String {
            [
                "from": connectedPeer.name,
                "id": id.uuidString,
                "text": text,
                "date": date.string(formatProvider: DateFormat.accurate)
            ].varDescription
        }
        
        public static func == (
            lhs: MPEngine.Payload,
            rhs: MPEngine.Payload
        ) -> Bool {
            lhs.id == rhs.id
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }
        
        public init(
            connectedPeer: MPEngine.Peer,
            text: String,
            date: Date
        ) {
            self.connectedPeer = connectedPeer
            self.text = text
            self.date = date
        }
    }
    
    public actor DataStore {
//        @Published
//        public private(set) var state: State = .stopped
//
//        func setState(_ newState: State) {
//            state = newState
//        }
//
//        @Published
//        public private(set) var invitations: [Invititation] = []
//
//        func removeAllInvitations() {
//            invitations.removeAll()
//        }
//
//        func appendInvitation(_ invitation: Invititation) {
//            invitations.append(invitation)
//        }
//
//        func refreshInvitations() {
//            self.invitations = invitations
//        }
        #warning("TODO: zakkhoyt - This dict should contain contributions from this peer")
        @Published
        public private(set) var connectedPeers = OrderedDictionary<Peer, [String]>()
        
        func removeAllConnectedPeers() {
            connectedPeers.removeAll()
        }
        
        func removeConnectedPeer(_ peer: Peer) {
            connectedPeers[peer] = nil
        }

        func insertConnectedPeer(_ peer: Peer, payloads: [String]) {
            connectedPeers[peer] = payloads
        }
        
//        func refreshInvitations() {
//            self.invitations = invitations
//        }

        @Published
        public private(set) var payloads = [Payload]()
        
        func removePayloads() {
            payloads.removeAll()
        }
        
        func prependPayload(_ payload: Payload) {
            payloads.insert(payload, at: 0)
        }
        
        func refreshPayloads() {
            payloads = payloads
        }
    }
    
    public let dataStore = DataStore()

    public var peerDisplayName: String {
        peerID.displayName
    }

    // MARK: Private vars
    
    private let session: MCSession
    private let peerID: MCPeerID
    
    private var advertiser: Advertiser?
    private var browser: Browser?
    
    private var subscriptions = Set<AnyCancellable>()

    public init(
        displayName: String, // UIDevice.current.name
        encryption: Encryption = .required
    ) {
        self.peerID = MCPeerID(displayName: displayName)
        self.session = MCSession(
            peer: peerID,
            securityIdentity: nil, // unsuppored by this SDK for now.
            encryptionPreference: encryption.mcEncryptionPreference
        )
        super.init()
        session.delegate = self
    }
    
    public func disconnect() {
        session.disconnect()
    }
    
    // MARK: Advertising
    
    public func startAdvertising(
        serviceName: String,
        discoveryInfo: [String: String]?
    ) -> Advertiser {
        let advertiser: Advertiser = {
            guard let advertiser = self.advertiser,
                  advertiser.serviceType == serviceName,
                  advertiser.discoveryInfo == discoveryInfo
            else {
                return Advertiser(
                    peerID: peerID,
                    serviceType: serviceName,
                    discoveryInfo: discoveryInfo
                )
            }
            
            return advertiser
        }()
        
        advertiser.startAdvertising()
        self.advertiser = advertiser
        
        Task {
            await advertiser.dataStore.$invitations.sink { [weak self] invitations in
                guard let self else { return }
                
                Task {
                    // Auto accept invitation if configuration supports it.
                    if ProcessInfo.processInfo.arguments.contains("--advertiser-auto-accept-invitataions") {
                        invitations.forEach {
                            if case .noResponse = $0.response {
                                self.respond(invitation: $0, accept: true)
                            }
                        }
                    }
                }
            }
            .store(in: &subscriptions)
        }
        
        return advertiser
    }
    
    public func stopAdvertising() {
        advertiser?.stopAdvertising()
    }

    public func respond(
        invitation: Advertiser.Invititation,
        accept: Bool
    ) {
        advertiser?.respond(
            invitation: invitation,
            accept: accept,
            session: session
        )
    }
    
    // MARK: Browsing
    
    public func startBrowsing(
        serviceName: String
    ) -> Browser {
        let browser: Browser = {
            guard let browser = self.browser,
                  browser.serviceType == serviceName
            else {
                return Browser(
                    peerID: peerID,
                    serviceType: serviceName
                )
            }
            
            return browser
        }()
        browser.startBrowsing()
        self.browser = browser
        return browser
    }
    
    public func stopBrowsing() throws {
        browser?.stopBrowsing()
    }
    
    public func invite(
        service: MPEngine.Browser.Service,
        context: Data? = nil,
        timeout: TimeInterval
    ) {
        browser?.invite(
            service: service,
            session: session,
            context: context,
            timeout: 10
        )
    }
    
    // MARK: Data Transfer
    
    public enum Recipients {
        case all
        case peers([MPEngine.Peer])
    }
    
    public func send(
        data: Data,
        recipients: Recipients = .all
    ) throws {
        // let peerIDs: [MCPeerID] = [MCPeerID(displayName: "fake")]
        let peerIDs: [MCPeerID] = switch recipients {
        case .all:
            session.connectedPeers
        case .peers(let peers):
            // Instead of directly translating, let's instead filter them out
            session.connectedPeers.filter { peerID in
                peers.contains { peer in
                    peer.name == peerID.displayName
                }
            }
        }

        try session.send(
            data,
            toPeers: peerIDs,
            with: .reliable
        )
        
        logger.debug(
            """
            \(#function, privacy: .public):#\(#line) - \
            Did send payload of \(data.count) bytes to recipients: \(peerIDs.map { $0.displayName })
            """
        )
    }
    
    public func send(
        text: String
    ) throws {
        guard let data = text.data(using: .utf8) else {
            throw NSError()
        }
        try send(data: data)
        
        Task {
            await dataStore.prependPayload(
                Payload(
                    connectedPeer: Peer(peerID: peerID),
                    text: text,
                    date: .now
                )
            )
        }
    }
    
    // MARK: Private functions
    
    private func peers(
        peerIDs: [MCPeerID]
    ) -> [Peer] {
        peerIDs.map { Peer(peerID: $0) }
    }
}

extension MPEngine: MCSessionDelegate {
    // Remote peer changed state.
    public func session(
        _ session: MCSession,
        peer peerID: MCPeerID,
        didChange state: MCSessionState
    ) {
        let connectedPeer = Peer(peerID: peerID)
        
        Task {
            logger.debug(
                """
                \(#function, privacy: .public):#\(#line) - \
                peer: \(peerID.displayName, privacy: .public) \
                didChange: \(state, privacy: .public)
                """
            )

            switch state {
            case .notConnected:
                await dataStore.removeConnectedPeer(connectedPeer)
            case .connecting:
                await dataStore.removeConnectedPeer(connectedPeer)
            case .connected:
                await dataStore.insertConnectedPeer(connectedPeer, payloads: [])
            @unknown default:
                break
            }
            
            // Tell our browser instance about any changes so it can update invitations
            browser?.session(session, peer: peerID, didChange: state)
        }
    }
    
    // Received data from remote peer.
    public func session(
        _ session: MCSession,
        didReceive data: Data,
        fromPeer peerID: MCPeerID
    ) {
        logger.debug(
            """
            \(#function, privacy: .public):#\(#line) - \
            data: \(data.count, privacy: .public) \
            fromPeer: \(peerID.displayName, privacy: .public)
            """
        )
        
//        let connectedPeer = ConnectedPeer(peerID: peerID)
        guard let text = String(data: data, encoding: .utf8) else {
            assertionFailure()
            return
        }
        
        Task {
            await dataStore.prependPayload(
                Payload(
                    connectedPeer: Peer(peerID: peerID),
                    text: text,
                    date: Date()
                )
            )
        }
    }
    
    // Received a byte stream from remote peer.
    public func session(
        _ session: MCSession,
        didReceive stream: InputStream,
        withName streamName: String,
        fromPeer peerID: MCPeerID
    ) {
        logger.debug(
            """
            \(#function, privacy: .public):#\(#line) - \
            stream: \(stream, privacy: .public) \
            withName: \(streamName, privacy: .public) \
            fromPeer: \(peerID.displayName, privacy: .public)
            """
        )
    }
    
    // Start receiving a resource from remote peer.
    public func session(
        _ session: MCSession,
        didStartReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        with progress: Progress
    ) {
        logger.debug(
            """
            \(#function, privacy: .public):#\(#line) - \
            didStartReceivingResourceWithName: \(resourceName, privacy: .public) \
            fromPeer: \(peerID.displayName, privacy: .public) \
            progress: \(String(format: "%.01f", progress.fractionCompleted), privacy: .public)
            """
        )
    }
    
    // Finished receiving a resource from remote peer and saved the content
    // in a temporary location - the app is responsible for moving the file
    // to a permanent location within its sandbox.
    public func session(
        _ session: MCSession,
        didFinishReceivingResourceWithName resourceName: String,
        fromPeer peerID: MCPeerID,
        at localURL: URL?,
        withError error: (any Error)?
    ) {
        logger.debug(
            """
            \(#function, privacy: .public):#\(#line) - \
            didFinishReceivingResourceWithName: \(resourceName, privacy: .public) \
            fromPeer: \(peerID.displayName, privacy: .public) \
            at: \(localURL?.absoluteString ?? "<nil>", privacy: .public) \
            error: \(error?.localizedDescription ?? "<nil>", privacy: .public)
            """
        )
    }
    
//    // Made first contact with peer and have identity information about the
//    // remote peer (certificate may be nil).
//    public func session(
//        _ session: MCSession,
//        didReceiveCertificate certificate: [Any]?,
//        fromPeer peerID: MCPeerID,
//        certificateHandler: @escaping (Bool) -> Void
//    ) {
//        logger.debug(
//            """
//            \(#function, privacy: .public):#\(#line) - \
//            didReceiveCertificate: \((certificate ?? []).description, privacy: .public) \
//            fromPeer: \(peerID.displayName, privacy: .public)
//            """
//        )
//    }
}
