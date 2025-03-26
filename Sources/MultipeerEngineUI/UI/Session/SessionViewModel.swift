//
//  SessionViewModel.swift
//  MPEngineDevApp
//
//  Created by Zakk Hoyt on 12/4/23.
//

import BaseUtility
@preconcurrency import Collections
@preconcurrency import Combine
import Foundation
public import MultipeerEngine
public import SwiftUI

@Observable @MainActor
public final class SessionViewModel {
    // MARK: Nested Types

    struct PayloadWrapper: PayloadRepresentable {
        // MARK: Internal vars
        
        let isMine: Bool
        
        // MARK: Private vars
        
        private let payload: MPEngine.Payload
        
        // MARK: Implements MPEngine.PayloadRepresentable

        var id: UUID { payload.id }
        var connectedPeer: MPEngine.Peer { payload.connectedPeer }
        var text: String { payload.text }
        var date: Date { payload.date }
        let time: String

        // MARK: Internal inits
        
        init(
            payload: MPEngine.Payload,
            isMine: Bool
        ) {
            self.payload = payload
            self.isMine = isMine
            self.time = payload.date.string(formatProvider: DateFormat.hourMinuteSecond)
        }
        
        static func convert(
            payloads: [MPEngine.Payload],
            engine: MPEngine
        ) -> [SessionViewModel.PayloadWrapper] {
            payloads.map {
                SessionViewModel.PayloadWrapper(
                    payload: $0,
                    isMine: $0.connectedPeer.name == engine.peerDisplayName
                )
            }
        }
    }
    
    // MARK: Internal vars
    
    let engine: MPEngine
    private(set) var connectedPeers: OrderedDictionary<MPEngine.Peer, [String]> = [:]
    
    //    private(set) var payloads: [MPEngine.Payload] = []
    private(set) var payloadWrappers: [PayloadWrapper] = []
    
    // MARK: Private vars
    
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: Internal inits
    
    public init(
        engine: MPEngine
    ) {
        self.engine = engine
        
        Task {
            self.connectedPeers = await engine.dataStore.connectedPeers
            await self.engine.dataStore.$connectedPeers
                .receive(on: DispatchQueue.main)
                .sink { [weak self] connectedPeers in
                    guard let self else { return }
                    self.connectedPeers = connectedPeers
                
                    logger.debug(
                        """
                        \(#file) - \(#function, privacy: .public):\(#line) \
                        count: \(self.connectedPeers.count, privacy: .public)
                        """
                    )
                }
                .store(in: &subscriptions)
            
            self.payloadWrappers = await PayloadWrapper.convert(
                payloads: engine.dataStore.payloads,
                engine: engine
            )

            await self.engine.dataStore.$payloads
                .receive(on: DispatchQueue.main)
                .sink { [weak self] payloads in
                    guard let self else { return }
                    self.payloadWrappers = PayloadWrapper.convert(
                        payloads: payloads,
                        engine: engine
                    )
                                
                    logger.debug(
                        """
                        \(#file) - \(#function, privacy: .public):\(#line) \
                        count: \(self.payloadWrappers.count, privacy: .public)
                        """
                    )
                }
                .store(in: &subscriptions)
            
            logger.debug(
                """
                \(#file) - \(#function, privacy: .public):\(#line)
                """
            )
        }
    }
}
