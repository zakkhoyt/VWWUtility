//
//  SongTrack.swift
//
//  Created by Zakk Hoyt on 6/22/23.
//

import Foundation
import WaveSynthesizer

struct SongTrack {
    let melody: Melody
    let instrument: Instrument
}

extension SongTrack {
    static let spinnaker = SongTrack(melody: .spinnaker, instrument: .sharpTriangle)
    static let zeldaKey = SongTrack(melody: .zeldaKey, instrument: .sharpTriangle)
    
    static func modify(
        songTrack: SongTrack,
        waveformType: WaveformType,
        transpose: Int = 0,
        octave: Int = 0
    ) -> SongTrack {
        var instrument = songTrack.instrument
        instrument.waveformType = waveformType
        var melody = songTrack.melody
        melody.transpose = transpose
        melody.octave = octave
        return SongTrack(melody: melody, instrument: instrument)
    }
}

