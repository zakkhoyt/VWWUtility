//
//  BrowserViewModel.swift
//  MPEngineDevApp
//
//  Created by Zakk Hoyt on 12/4/23.
//

import Combine
import Foundation
import MultipeerEngine
import SwiftUI

@Observable @MainActor
final class BrowserViewModel {
    // MARK: Internal vars
    
    let engine: MPEngine
    private(set) var advertisedServices: [MPEngine.Browser.Service] = []
    var isPresentingSession = false
    
    // MARK: Private vars
    
    private let browser: MPEngine.Browser
    private var subscriptions = Set<AnyCancellable>()
    
    // MARK: Internal inits
    
    init(
        engine: MPEngine,
        browser: MPEngine.Browser
    ) {
        self.engine = engine
        self.browser = browser
        
        Task {
            //        updateAdvertisedServices(browser.advertisedServices.value)
            self.advertisedServices = await browser.dataStore.advertisedServices
            
            await self.browser.dataStore.$advertisedServices
                .receive(on: DispatchQueue.main)
                .sink { [weak self] advertisedServices in
                    guard let self else { return }
                    //            DispatchQueue.main.async {
                    
                    //            updateAdvertisedServices(advertisedServices)
                    self.advertisedServices = advertisedServices
                    
                    logger.debug(
                        """
                        \(#file) - \(#function, privacy: .public):\(#line) \
                        count: \(self.advertisedServices.count, privacy: .public)
                        """
                    )
                    //            }
                }
                .store(in: &subscriptions)
            
            logger.debug(
                """
                \(#file) - \(#function, privacy: .public):\(#line)
                """
            )
        }
    }
    
    func pushSession() {
        isPresentingSession = true
        logger.debug(
            """
            \(#file) - \(#function, privacy: .public):\(#line) \
            Setting isPresentingSession = true
            """
        )
    }
    
    private func updateAdvertisedServices(
        _ advertisedServices: [MPEngine.Browser.Service]
    ) {
        self.advertisedServices = advertisedServices
        
        logger.debug(
            """
            \(#file) - \(#function, privacy: .public):\(#line) \
            count: \(self.advertisedServices.count, privacy: .public)
            """
        )
        
        func autoPushSessionIfNeeded() {
            if ProcessInfo.processInfo.arguments.contains("--browser-auto-push-session") {
                logger.debug(
                    """
                    \(#file) - \(#function, privacy: .public):\(#line) \
                    Flag detected: --browser-auto-push-session. Checking for accepted invitations...
                    """
                )
                
                let acceptedInvitations = advertisedServices.filter {
                    if case .invitationAccepted = $0.invitationState {
                        true
                    } else {
                        false
                    }
                }
                logger.debug(
                    """
                    Found \(acceptedInvitations.count) accepted invitations.
                    """
                )
                
                if !acceptedInvitations.isEmpty {
                    logger.debug(
                        """
                        calling self.pushSession()
                        """
                    )
                    pushSession()
                }
            }
        }
        autoPushSessionIfNeeded()
    }
}
