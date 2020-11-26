//
//  FilterConductor.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/23/20.
//

import Foundation
import AudioKit
import AVFoundation

protocol GameConductor {
        
    func startPlaying()
    
    func stopPlaying()
    
    func fireScoreFeedback(successLevel: ScoreSuccessLevel)
    
}


// TODO: Create protocol
class EqualizerFilterConductor: GameConductor {
    
    // MARK: - Types
    
    // MARK: - Properties
    
    // MARK: Internal
    
    private(set) var filterGainDB: AUValue
    private(set) var filterQ: AUValue
    
    lazy var volume: AUValue = AudioMath.dBToPercent(dB: -8)
    
    var isMuted = false {
        didSet {
            if isMuted != oldValue {
                mute(isMuted)
            }
        }
    }
        
    // MARK: Private
    
    private var fxManager = SoundFXManager.main
    private let engine = AudioEngine()
    private let player = AudioPlayer()
    private let fxPlayer = AudioPlayer()
    private let mixer: Mixer
    private let filter: EqualizerFilter
    private var fader: Fader
    private let buffer: AVAudioPCMBuffer
    private let filterRampTime: AUValue = 0.05
    private let dimVolume: AUValue = AudioMath.dBToPercent(dB: -6)

    
    // MARK: - Initializers
    
    init(source: AudioSource = AudioSource.acousticDrums,
         filterGainDB: AUValue,
         filterQ: AUValue) {
        buffer = Cookbook.buffer(for: source.url)
        self.filterGainDB = filterGainDB
        self.filterQ = filterQ

        filter = EqualizerFilter(player)
        filter.centerFrequency = 1000
        filter.gain = 1
        filter.bandwidth = 1000
        
        fader = Fader(filter, gain: 0)
        
        mixer = Mixer([fader, fxPlayer])
        
        player.volume = volume
        fxPlayer.volume = volume

        engine.output = mixer
        
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func startPlaying() {
        startEngine()
        player.start()
        fadeIn()
    }
    
    func stopPlaying() {
        fadeOut()
        player.stop()
        engine.stop()
    }
    
    func fireScoreFeedback(successLevel: ScoreSuccessLevel) {
        let buffer = fxManager.buffer(for: successLevel)
        fxPlayer.scheduleBuffer(buffer, at: nil, options: AVAudioPlayerNodeBufferOptions.interrupts)
        fxPlayer.play()
    }
    
    func mute(_ muted: Bool) {
        if muted {
            fadeOut()
        } else {
            fadeIn()
        }
    }
    
    func toggleMute() {
        isMuted.toggle()
    }
    
    func setFilterBypass(_ bypass: Bool) {
        let gain = bypass ? 1.0 : filterGainDB
        set(filterGainDB: gain)
    }
    
    func setDim(dimmed: Bool) {
        let gain = dimmed ? dimVolume : volume
        
        fader.$leftGain.ramp(to: gain, duration: 0.3)
        fader.$rightGain.ramp(to: gain, duration: 0.3)
    }
        
    func set(filterFreq: AUValue) {
        let bandwidth = filterFreq / filterQ
        filter.$centerFrequency.ramp(to: filterFreq, duration: filterRampTime)
        filter.$bandwidth.ramp(to: bandwidth, duration: filterRampTime)
    }
    
    func set(filterGainDB: AUValue) {
        let gainPercentage = AudioMath.dBToPercent(dB: filterGainDB)
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
