//
//  MPEngine.swift
//
//  Created by Zakk Hoyt on 12/2/23.
//

// https://www.hackingwithswift.com/example-code/networking/how-to-create-a-peer-to-peer-network-using-the-multipeer-connectivity-framework
// https://www.kodeco.com/12689804-getting-started-with-multipeer-connectivity

import Collections
import Foundation
import MultipeerConnectivity

public final class MPEngine: NSObject {
    public class ConnectedPeer: Identifiable, Hashable, CustomStringConvertible {
        // public let id = UUID()
        public var id: String { name }
        public let name: String
        
        public var description: String {
            #warning("TODO: zakkhoyt - VWWUtil, list to description or, reflection, etc..")
            let valueStrings = [
                "id: \(id)",
                "name: \(name)"
            ]
            
            return valueStrings.joined(separator: ", ")
        }
        
        public static func == (
            lhs: MPEngine.ConnectedPeer,
            rhs: MPEngine.ConnectedPeer
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
    
    public class Payload: Identifiable, Hashable {
        public let id = UUID()
        public let connectedPeer: ConnectedPeer
        public let text: String
        public let date: Date
        
        public var description: String {
            #warning("TODO: zakkhoyt - VWWUtil, list to description or, reflection, etc..")
            let valueStrings = [
                "id: \(id.uuidString)",
                "text: \(text)",
                "date: \(date)"
            ]
            
            return valueStrings.joined(separator: ", ")
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
            connectedPeer: MPEngine.ConnectedPeer,
            text: String,
            date: Date
        ) {
            self.connectedPeer = connectedPeer
            self.text = text
            self.date = date
        }
    }
    
    #warning("TODO: zakkhoyt - This dict should contain contributions from this peer")
    public var didUpdateConnectedPeers: ((OrderedDictionary<ConnectedPeer, [String]>) -> Void)?
    public private(set) var connectedPeers: OrderedDictionary<ConnectedPeer, [String]> = [:] {
        didSet {
            logger.debug(
                """
                [DEBUG] \(#file) - \(#function, privacy: .public):\(#line) \
                count: \(self.connectedPeers.count, privacy: .public)
                """
            )
            didUpdateConnectedPeers?(connectedPeers)
        }
    }

    public var didUpdatePayloads: (([Payload]) -> Void)?
    public private(set) var payloads: [Payload] = [] {
        didSet {
            logger.debug(
                """
                [DEBUG] \(#file) - \(#function, privacy: .public):\(#line) \
                count: \(self.payloads.count, privacy: .public)
                """
            )
            didUpdatePayloads?(payloads)
        }
    }

    public var peerDisplayName: String {
        peerID.displayName
    }
    
    public private(set) var advertiser: Advertiser?
    public private(set) var browser: Browser?
    
    private let session: MCSession
    private let peerID: MCPeerID
    
    public init(
        displayName: String // UIDevice.current.name
    ) {
        self.peerID = MCPeerID(displayName: displayName)
        #warning("TODO: zakkhoyt - encryption via injection")
        self.session = MCSession(
            peer: peerID,
            securityIdentity: nil,
            encryptionPreference: .none
        )
        super.init()
        session.delegate = self
    }
    
    public func disconnect() {
        session.disconnect()
    }
    
    // MARK: Advertising
    
    #warning("FIXME: zakkhoyt - Should this return Advertiser instance?")
    public func startAdvertising(
        serviceName: String
    ) {
        if advertiser == nil {
            advertiser = Advertiser(
                peerID: peerID,
                serviceType: serviceName
            )
        }
        advertiser?.startAdvertising()
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
    
    #warning("FIXME: zakkhoyt - Should this return Browser instance?")
    public func startBrowsing(
        serviceName: String
    ) {
        if browser == nil {
            browser = Browser(
                peerID: peerID,
                serviceType: serviceName
            )
        }
        browser?.startBrowsing()
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
    
    public func send(
        data: Data
    ) throws {
        try session.send(
            data,
            toPeers: session.connectedPeers,
            with: .reliable
        )
    }
    
    public func send(
        text: String
    ) throws {
        guard let data = text.data(using: .utf8) else {
            throw NSError()
        }
        try send(data: data)
        
        payloads.insert(
            Payload(
                connectedPeer: ConnectedPeer(peerID: peerID),
                text: text,
                date: .now
            ),
            at: 0
        )
    }
}

extension MPEngine: MCSessionDelegate {
    // Remote peer changed state.
    public func session(
        _ session: MCSession,
        peer peerID: MCPeerID,
        didChange state: MCSessionState
    ) {
        logger.debug(
            """
            [DEBUG] \(#function, privacy: .public):\(#line) \
            peer: \(peerID.displayName, privacy: .public) \
            didChange: \(state, privacy: .public)
            """
        )
        
        #warning("FIXME: zakkhoyt - wrap in actor instead of doing this queue casting")
        Task {
            await MainActor.run {
                let connectedPeer = ConnectedPeer(peerID: peerID)
                switch state {
                case .notConnected:
                    connectedPeers[connectedPeer] = nil
                case .connecting:
                    connectedPeers[connectedPeer] = nil
                case .connected:
                    connectedPeers[connectedPeer] = []
                @unknown default:
                    break
                }
            }
        }
        
        browser?.session(session, peer: peerID, didChange: state)
    }
    
    // Received data from remote peer.
    public func session(
        _ session: MCSession,
        didReceive data: Data,
        fromPeer peerID: MCPeerID
    ) {
        logger.debug(
            """
            [DEBUG] \(#function, privacy: .public):\(#line) \
            data: \(data.count, privacy: .public) \
            fromPeer: \(peerID.displayName, privacy: .public)
            """
        )
        
//        let connectedPeer = ConnectedPeer(peerID: peerID)
        guard let text = String(data: data, encoding: .utf8) else {
            assertionFailure()
            return
        }
        
        payloads.insert(
            Payload(
                connectedPeer: ConnectedPeer(peerID: peerID),
                text: text,
                date: Date()
            ),
            at: 0
        )
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
            [DEBUG] \(#function, privacy: .public):\(#line) \
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
            [DEBUG] \(#function, privacy: .public):\(#line) \
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
            [DEBUG] \(#function, privacy: .public):\(#line) \
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
//            [DEBUG] \(#function, privacy: .public):\(#line) \
//            didReceiveCertificate: \((certificate ?? []).description, privacy: .public) \
//            fromPeer: \(peerID.displayName, privacy: .public)
//            """
//        )
//    }
}
