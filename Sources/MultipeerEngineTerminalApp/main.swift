// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

// @Argument var mode: String
// an un-named value
//
//

import ArgumentParser
import BaseUtility
import Combine
import Foundation
import MultipeerEngine
import TerminalUtility

struct App: ParsableCommand, Sendable {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "MPEngine terminal app.",
            abstract: "Multiplatform data engine",
            discussion: "Multiplatform data engine"
        )
    }
    
    enum Mode: String, ExpressibleByArgument {
        case browser
        case advertiser
    }
    
    @Option
    var mode: Mode
    
    @Option
    var name: String

    @Option
    var serviceName: String

    @Flag(
        name: [.long, .customLong("debug")],
        help: "Verbose debug logging to stderr"
    )
    var isDebugMode = false
    
    class Helpers: Codable {
        static let shared = Helpers()
        func encode(to encoder: any Encoder) throws {}
        
        required init(from decoder: any Decoder) throws {}
        
        init() {}

        var subscriptions = Set<AnyCancellable>()
    }
    
    func run() throws {
        print("mode: \(mode)")
        print("name: \(name)")
        print("serviceName: \(serviceName)")
        print("isDebugMode: \(isDebugMode)")
        
        Task {
            let engine = MPEngine(displayName: name)
            
            switch mode {
            case .browser:
            
                let browser = engine.startBrowsing(serviceName: serviceName)
                await browser.dataStore.$advertisedServices
                    .receive(on: DispatchQueue.main)
                    .sink { services in
                        print("found services: \(services)")
                    }
                    .store(in: &Helpers.shared.subscriptions)
            case .advertiser:
                let advertiser = engine.startAdvertising(
                    serviceName: serviceName,
                    discoveryInfo: [
                        MPEngine.Advertiser.DiscoveryInfo.activityKey: "Tic Tac Toe"
                    ]
                )
                await advertiser.dataStore.$invitations
                    .receive(on: DispatchQueue.main)
                    .sink { invitations in
                        print("did receive invitations: \(invitations)")
                        invitations.forEach {
                            switch $0.response {
                            case .noResponse:
                                engine.respond(invitation: $0, accept: true)
                            default:
                                break
                            }
                        }
                    }
                    .store(in: &Helpers.shared.subscriptions)
                
                await engine.dataStore.$payloads
                    .receive(on: DispatchQueue.main)
                    .sink { payloads in
                        guard let first = payloads.first else {
                            print("payloads updated but are empty")
                            return
                        }
                        guard first.connectedPeer.name != engine.peerDisplayName else {
                            print("payloads is from self. Ignoring. \(first.description)")
                            return
                        }
                    
                        print("Echoing payload \(first.description)")
                        try? engine.send(text: "echo \(first.text)")
                    }
                    .store(in: &Helpers.shared.subscriptions)
            }
        }
    }
}

App.main()

// This keeps the script open so our async events can run
RunLoop.main.run()
