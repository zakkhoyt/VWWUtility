public //
//  HomeViewModel.swift
//  MPEngineDevApp
//
//  Created by Zakk Hoyt on 12/4/23.
//

import BaseUtility
public import Foundation
public import MultipeerEngine
import SwiftUI

@Observable
public final class HomeViewModel {
    public enum NavigationDestinationData: Hashable, Identifiable {
        case advertiser(MPEngine.Advertiser)
        case browser(MPEngine.Browser)
        
        public var id: Int {
            switch self {
            case .advertiser: 1
            case .browser: 2
            }
        }
    }

    public let engine: MPEngine
    
    let versionAndBuild: String
    
    #warning("FIXME: zakkhoyt - We can do better with data structs. Replace the following 3 with 1. The hard part is .navigationDestination and such")
    var navigationDestinationData: NavigationDestinationData?
    var isPresentingAdvertiser = false
    var isPresentingBrowser = false
    
    public init(
        engine: MPEngine
    ) {
        self.engine = engine
        self.versionAndBuild = Bundle.main.versionAndBuildString ?? "<nil>"
        
        logger.debug(
            """
            \(#file) - \(#function, privacy: .public):\(#line)
            """
        )
        
//        if ProcessInfo.processInfo.arguments.contains("--mode=browser") {
//            startBrowsing()
//        } else if ProcessInfo.processInfo.arguments.contains("--mode=advertiser") {
//            startAdvertising()
//        }
    }
    
    func startAdvertising() {
        let advertiser = engine.startAdvertising(
            serviceName: ServiceName.testService,
            discoveryInfo: [
                MPEngine.Advertiser.DiscoveryInfo.activityKey: "Tic Tac Toe"
            ]
        )
        isPresentingAdvertiser = true
        navigationDestinationData = .advertiser(advertiser)
    }

    func startBrowsing() {
        let browser = engine.startBrowsing(serviceName: ServiceName.testService)
        isPresentingBrowser = true
        navigationDestinationData = .browser(browser)
    }
}
