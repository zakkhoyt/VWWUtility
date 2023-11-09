//
//  SongComposer.swift
//
//  Created by Zakk Hoyt on 6/22/23.
//

import BaseUtility
import WaveSynthesizer

class SongTrackSequencer {
    
    private let synth: WaveSynthesizer
    private let channel: Channel

    init() throws {
        self.synth = try WaveSynthesizer()
        self.channel = Channel(name: "SongTrackChannel")
        try synth.start()
    }

    
    func playSongTracks() async {
        var songTracks: [SongTrack] = []
        songTracks.append(contentsOf: WaveformType.allCases.enumerated().map {
//            .modify(songTrack: .spinnaker, waveformType: $0.element, transpose: $0.offset)
            
//            let transpose = Int.random(in: -12...12)
//            return .modify(songTrack: .spinnaker, waveformType: $0.element, transpose: transpose)
            
            .modify(songTrack: .zeldaKey, waveformType: $0.element)
        })
        
//        let spinnakers: [SongTrack] = WaveformType.allCases.map {
//            .spin(waveformType: $0),
//        }
        for await songTrack in AsyncArray(items: songTracks) {
            await play(songTrack: songTrack, channel: channel)
//            await channel.wait(for: restDuration)
            await Task.sleep(duration: 0.4)
        }
    }
    
    private func play(
        songTrack: SongTrack,
        channel: Channel
    ) async {
        // Configure channel with waveform, adsr, effects, etc...
        channel.frequency.transpose.value = Double(songTrack.melody.transpose)
        channel.frequency.octave.value = Double(songTrack.melody.octave)
        channel.adsr = songTrack.instrument.adsr
//        print(channel.adsr.effectDebugDescription)
        
        channel.waveformRenderer.waveform.enumValue = songTrack.instrument.waveformType
        print(channel.waveformRenderer.waveform.description)
//        print(channel.waveformRenderer.effectDebugDescription)
        
        songTrack.instrument.effects.enumerated().forEach {
//            print($0.element.effectDebugDescription)
            channel.appendOptionalEffect(effect: $0.element)
        }
        
        // Play notes
        for await keyPress in AsyncArray(items: songTrack.melody.keyPresses) {
            print("keyPress.note): \(keyPress.note.name) \(keyPress.note.index) \(keyPress.note.keyIndex)")
//            await channel.play(note: keyPress.note, for: keyPress.duration)
            await synth.play(note: keyPress.note, for: keyPress.duration, channel: channel)
//            await channel.wait(for: keyPress.delay)
            await Task.sleep(duration: keyPress.delay)
        }
        
        // Clean up
        channel.optionalEffects.enumerated().forEach {
            channel.removeOptionalEffect(at: $0.offset)
        }
    }
}

