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
    
    @Flag(
        name: [.long, .customLong("debug")],
        help: "Verbose debug logging to stderr"
    )
    var isDebugMode = false
    
    func run() throws {
        print("mode: \(mode)")
        print("isDebugMode: \(isDebugMode)")
        
        Task {
            let i = 44
            
            if i.isPowerOfTwo {
                print("\(i)isPowerOfTwo: true")
            } else {
                print("\(i)isPowerOfTwo: false")
            }
            
            Terminal.test()

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
