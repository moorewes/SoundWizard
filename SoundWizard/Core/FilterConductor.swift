//
//  FilterConductor.swift
//  AudioKitExperiments
//
//  Created by Wes Moore on 10/23/20.
//

import Foundation
import AudioKit
import AVFoundation

class EqualizerFilterConductor: ObservableObject {
    
    // MARK: - Types
    
    // MARK: - Properties
    
    // MARK: Internal
        
    // MARK: Private
    
    private let engine = AudioEngine()
    private let player = AudioPlayer()
    private let filter: EqualizerFilter
    private let buffer: AVAudioPCMBuffer
    private let filterRampTime: AUValue = 0.05
    private var filterQ: AUValue = 1
    
    // MARK: - Initializers
    
    init(source: AudioSource = AudioSource.acousticDrums) {
        buffer = Cookbook.buffer(for: source.url)

        filter = EqualizerFilter(player)
        filter.centerFrequency = 1000
        filter.gain = 1
        filter.bandwidth = 1000

        engine.output = filter
        player.volume = AudioCalculator.dBToPercent(dB: -8.0)
        
        startEngine()
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func startPlaying() {
        player.start()
    }
    
    func pausePlaying() {
        player.pause()
    }
    
    func stopPlaying() {
        player.stop()
        engine.stop()
    }
    
    func set(filterFreq: AUValue) {
        let bandwidth = filterFreq / filterQ
        filter.$centerFrequency.ramp(to: filterFreq, duration: filterRampTime)
        filter.$bandwidth.ramp(to: bandwidth, duration: filterRampTime)
    }
    
    func set(filterGainDB: AUValue) {
        let gainPercentage = AudioCalculator.dBToPercent(dB: filterGainDB)
        filter.$gain.ramp(to: gainPercentage, duration: filterRampTime)
    }
    
    func set(filterQ: AUValue) {
        self.filterQ = filterQ
        set(filterFreq: filter.centerFrequency)
    }
    
    // MARK: Private

    private func startEngine() {
        do {
            try engine.start()
        } catch let err {
            Log(err)
        }
        
        player.scheduleBuffer(buffer, at: nil, options: .loops)
    }

}
