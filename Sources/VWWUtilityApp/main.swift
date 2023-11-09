// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import Foundation
import WaveSynthesizer


struct App: ParsableCommand {
    static var configuration: CommandConfiguration {
        CommandConfiguration(
            commandName: "WaveSynthesizer terminal app.",
            abstract: "An audio wave synthesizer",
            discussion: "Sine, Square, Sawtooth, etc... with effects"
        )
    }
    
    func run() throws {
        Task {
            
            print("Note.Name.c4")
            let noteName = Note.Name.c4
            print("noteName: \(noteName.index)")
            let note = Notes.note(index: noteName.index)
            print("actual note: \(note.name) \(String(describing: note.index)) \(String(describing: note.keyIndex))")
            
            let note2 = Notes.note(name: noteName)
            print("actual note: \(note2.name) \(String(describing: note2.index)) \(String(describing: note2.keyIndex))")
            
            let note3 = Notes.note(keyIndex: noteName.keyIndex)
            print("actual note: \(note3.name) \(String(describing: note3.index)) \(String(describing: note3.keyIndex))")
            
            print("")
            
            
            //let helper = try SynthHelper()
//            await helper.playSongTracks()
            
            let sequencer = try SongTrackSequencer()
            await sequencer.playSongTracks()
            
        }
    }
}

App.main()

// This keeps the script open so our async events can run
RunLoop.main.run()

