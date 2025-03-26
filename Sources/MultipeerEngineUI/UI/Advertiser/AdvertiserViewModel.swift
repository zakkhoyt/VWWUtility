//
//  AdvertiserViewModel.swift
//  MPEngineDevApp
//
//  Created by Zakk Hoyt on 12/4/23.
//

import Combine
import Foundation
import MultipeerEngine
import SwiftUI

@Observable @MainActor
final class AdvertiserViewModel {
    // MARK: Internal vars
    
    let engine: MPEngine
    private(set) var invitations: [MPEngine.Advertiser.Invititation] = []
    var isPresentingSession = false
    
    // MARK: Private vars
    
    private let advertiser: MPEngine.Advertiser
    var subscriptions = Set<AnyCancellable>()
    
    // MARK: Internal inits
    
    init(
        engine: MPEngine,
        advertiser: MPEngine.Advertiser
    ) {
        self.engine = engine
        self.advertiser = advertiser
        
        Task {
            //        self.invitations = advertiser.invitations.value
            self.invitations = await advertiser.dataStore.invitations
            await advertiser.dataStore.$invitations
                .receive(on: DispatchQueue.main)
                .sink { [weak self] invitations in
                    guard let self else { return }
                    self.invitations = invitations
                    
                    logger.debug(
                        """
                        \(#file) - \(#function, privacy: .public):\(#line) \
                        self.invitations.count: \(self.invitations.count, privacy: .public)
                        """
                    )
                }
                .store(in: &subscriptions)
        }
        logger.debug(
            """
            \(#file) - \(#function, privacy: .public):\(#line)
            """
        )
    }
}
