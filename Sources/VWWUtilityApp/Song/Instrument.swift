//
//  Instrument.swift
//
//  Created by Zakk Hoyt on 6/22/23.
//

import Foundation
import WaveSynthesizer

struct Instrument {
    var waveformType: WaveformType
    var adsr: ADSR
    var effects: [any Effect]
}

extension Instrument {
    static let sharpTriangle = Instrument(
        waveformType: .triangle,
        adsr: .sharp(),
        effects: []
    )
    
    static let bassGroove = Instrument(
        waveformType: .sawtooth,
        adsr: .bowed(),
        effects: []
    )
}
