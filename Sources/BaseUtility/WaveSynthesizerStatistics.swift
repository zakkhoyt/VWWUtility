//
//  WaveSynthesizerStatistics.swift
//
//  Created by Zakk Hoyt on 6/29/23.
//

import Foundation

public struct WaveSynthesizerStatistics {
    public struct Statistic {
        public var count: Int = 0
        public var perSecond: Double = 0.0
        
        init(
            count: Int = 0,
            perSecond: Double = 0.0
        ) {
            self.count = count
            self.perSecond = perSecond
        }
    }
    
    public struct Statistics {
        public var samplesPerFrame = 0
        public var startDate = Date()
        public var frames = Statistic()
        public var samples = Statistic()
        
        init(
            startDate: Date = Date(),
            frames: Statistic = Statistic(),
            samples: Statistic = Statistic()
        ) {
            self.startDate = startDate
            self.frames = frames
            self.samples = samples
        }
    }

    public let audioStatistics: Statistics
    public let visualAudioStatistics: Statistics
    
    public init() {
        self.audioStatistics = Statistics()
        self.visualAudioStatistics = Statistics()
    }
    
    public init(
        audioStatistics: Statistics,
        visualAudioStatistics: Statistics
    ) {
        self.audioStatistics = audioStatistics
        self.visualAudioStatistics = visualAudioStatistics
    }
}

public final class StatisticsManager {
    private var statistics = WaveSynthesizerStatistics.Statistics()
    
    public init() {}
    
    public func reset() {
        statistics.startDate = Date()
        statistics.frames.count = 0
        statistics.samples.count = 0
    }
    
    public func compute(
        sampleCount newSampleCount: Int
    ) -> WaveSynthesizerStatistics.Statistics {
        let elapsed = Date().timeIntervalSince(statistics.startDate)
        statistics.samplesPerFrame = newSampleCount
        statistics.frames.count += 1
        statistics.frames.perSecond = Double(statistics.frames.count) / elapsed
        statistics.samples.count += newSampleCount
        statistics.samples.perSecond = Double(statistics.samples.count) / elapsed
        return statistics
    }
}
