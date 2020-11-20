//
//  FilterConductor.swift
//  SoundWizard
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
    
    lazy var volume: AUValue = AudioCalculator.dBToPercent(dB: -0.8)
        
    // MARK: Private
    
    private let engine = AudioEngine()
    private let player = AudioPlayer()
    private let filter: EqualizerFilter
    private var fader: Fader
    private let buffer: AVAudioPCMBuffer
    private let filterRampTime: AUValue = 0.05
    private var filterQ: AUValue = 1
    private let dimVolume: AUValue = AudioCalculator.dBToPercent(dB: -6)
    
    // MARK: - Initializers
    
    init(source: AudioSource = AudioSource.acousticDrums) {
        buffer = Cookbook.buffer(for: source.url)

        filter = EqualizerFilter(player)
        filter.centerFrequency = 1000
        filter.gain = 1
        filter.bandwidth = 1000
        
        fader = Fader(filter, gain: 0)

        engine.output = fader
        player.volume = volume
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func startPlaying() {
        startEngine()
        player.start()
        fadeIn()
    }
    
    func mute(_ muted: Bool) {
        if muted {
            fadeOut()
        } else {
            fadeIn()
        }
    }
    
    func setDim(dimmed: Bool) {
        let gain = dimmed ? dimVolume : volume
        
        fader.$leftGain.ramp(to: gain, duration: 0.3)
        fader.$rightGain.ramp(to: gain, duration: 0.3)
    }
    
    func stopPlaying() {
        fadeOut()
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
    
    private func fadeIn() {
        fade(fadeIn: true)
    }
    
    private func fadeOut() {
        fade(fadeIn: false)
    }
    
    private func fade(fadeIn: Bool) {
        let gain: AUValue = fadeIn ? 1 : 0
        
        fader.$leftGain.ramp(to: gain, duration: 0.3)
        fader.$rightGain.ramp(to: gain, duration: 0.3)
    }


}
