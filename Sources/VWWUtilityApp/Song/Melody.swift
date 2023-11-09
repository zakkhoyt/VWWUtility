//
//  Melody.swift
//
//  Created by Zakk Hoyt on 6/22/23.
//

import Foundation
import WaveSynthesizer

struct Melody {
    struct KeyPress {
//        let noteName: Note.Name
        let note: Note
        let duration: TimeInterval
        let delay: TimeInterval
        
        init(
            noteName: Note.Name,
            duration: TimeInterval,
            delay: TimeInterval
        ) {
            self.note = Notes.note(name: noteName)
            self.duration = duration
            self.delay = delay
        }
        
        init(
            index: Int,
            duration: TimeInterval,
            delay: TimeInterval
        ) {
            self.note = Notes.note(index: index)
            self.duration = duration
            self.delay = delay
        }
    }
    
    let keyPresses: [KeyPress]
    var transpose: Int = 0
    var octave: Int = 0
}

extension Melody {
    static let spinnaker = {
        let duration: TimeInterval = 0.1
        let delay: TimeInterval = 0.025
        return Melody(
            keyPresses: [
                .init(noteName: .c4, duration: duration, delay: delay),
                .init(noteName: .a5, duration: duration, delay: delay),
                .init(noteName: .b5, duration: duration, delay: delay),
                .init(noteName: .c8, duration: duration, delay: delay)
            ]
        )
    }()
    
    static let zeldaKey = {
        let duration: TimeInterval = 0.1
        let delay: TimeInterval = 0.0125
        return Melody(
            keyPresses: [
                .init(noteName: .cSharp5, duration: duration, delay: delay),
                .init(noteName: .e6, duration: duration, delay: delay),
                .init(noteName: .b6, duration: duration, delay: delay),
                .init(noteName: .g6, duration: duration, delay: delay),
                .init(noteName: .b6, duration: duration, delay: delay),
            ]
        )
    }()
    
//    static let spinnaker_low = {
//        let duration: TimeInterval = 0.1
//        let delay: TimeInterval = 0.025
//        return Melody(
//            keyPresses: [
//                .init(noteName: .c1, duration: duration, delay: delay),
//                .init(noteName: .a2, duration: duration, delay: delay),
//                .init(noteName: .b2, duration: duration, delay: delay),
//                .init(noteName: .c4, duration: duration, delay: delay)
//            ]
//        )
//    }()
}


