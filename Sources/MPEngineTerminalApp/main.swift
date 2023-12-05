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
import Foundation
import MPEngine
import TerminalUtility

struct App: ParsableCommand {
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
    
    func run() throws {
        print("mode: \(mode)")
        print("name: \(name)")
        print("serviceName: \(serviceName)")
        print("isDebugMode: \(isDebugMode)")
        
        Task {
//            let i = 44
            
//            
//            if i.isPowerOfTwo {
//                print("\(i)isPowerOfTwo: true")
//            } else {
//                print("\(i)isPowerOfTwo: false")
//            }
//            
//            Terminal.test()

            print("Enter your name: ")
            if let str = readLine(strippingNewline: true) {
                print("You entered: \(str)")
            } else {
                print("Failed to collect your name")
            }

            let engine = MPEngine(displayName: name)
            
            switch mode {
            case .browser:
            
                engine.startBrowsing(serviceName: serviceName)
                guard let browser = engine.browser else {
                    preconditionFailure("browser == nil")
                }
                browser.didUpdateAdvertisedServices = { services in
                    print("found services: \(services)")
                }
            case .advertiser:
                engine.startAdvertising(serviceName: serviceName)
                guard let advertiser = engine.advertiser else {
                    preconditionFailure("advertiser == nil")
                }
                advertiser.didUpdateInvitations = { invitations in
                    print("did receive invitations: \(invitations)")
                }
            }
            
            
            try? await Task.sleep(nanoseconds: 10_000_000_000)
            print("Enter your name: ")
            if let str = readLine(strippingNewline: true) {
                print("You entered: \(str)")
            } else {
                print("Failed to collect your name")
            }
        
//
//            let sequencer = try SongTrackSequencer()
//            await sequencer.playSongTracks()
        }
    }
}

App.main()

// This keeps the script open so our async events can run
RunLoop.main.run()
