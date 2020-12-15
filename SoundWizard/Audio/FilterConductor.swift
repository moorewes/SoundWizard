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
    
    var outputFader: Fader { get }
        
    func startPlaying()
    
    func stopPlaying()
        
}

class EQDetectiveConductor: GameConductor {
            
    // MARK: - Properties
    
    // MARK: Internal
    
    private(set) var filterGainDB: AUValue
    private(set) var filterQ: AUValue
    let outputFader: Fader
    
    lazy var volume: AUValue = AudioMath.dBToPercent(dB: -8)
    
    var isMuted = false {
        didSet {
            if isMuted != oldValue {
                mute(isMuted)
            }
        }
    }
        
    // MARK: Private
    private let masterConductor = Conductor.master
    private let player = AudioPlayer()
    private let filter: EqualizerFilter
    private let buffer: AVAudioPCMBuffer
    private let filterRampTime: AUValue = 0.25
    private let dimVolume: AUValue = AudioMath.dBToPercent(dB: -6)
    private let defaultFadeTime: Float = 1.5

    
    // MARK: - Initializers
    
    init(source: AudioMetadata,
         filterGainDB: AUValue,
         filterQ: AUValue) {
        self.buffer = Cookbook.buffer(for: source.url)
        self.filterGainDB = filterGainDB
        self.filterQ = filterQ

        filter = EqualizerFilter(player)
        filter.centerFrequency = 1000
        filter.gain = 1
        filter.bandwidth = 1000
        
        outputFader = Fader(filter, gain: 0)
                
        player.volume = volume
        
        masterConductor.patchIn(self)
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func startPlaying() {
        player.scheduleBuffer(buffer, at: nil, options: .loops)
        player.start()
        fadeIn()
    }
        
    func stopPlaying() {
        fadeOutAndStop(duration: defaultFadeTime)
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
        
        outputFader.$leftGain.ramp(to: gain, duration: 0.3)
        outputFader.$rightGain.ramp(to: gain, duration: 0.3)
    }
        
    func set(filterFreq: AUValue) {
        let bandwidth = filterFreq / filterQ
        
        filter.gain = 1
        filter.$centerFrequency.ramp(to: filterFreq, duration: filterRampTime)
        filter.$bandwidth.ramp(to: bandwidth, duration: filterRampTime)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.filter.$gain.ramp(to: self.filterGainDB, duration: self.filterRampTime)
        }
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
    
    private func fadeIn() {
        fade(to: 1)
    }
    
    private func fadeOut() {
        fade(to: 0)
    }
    
    private func fade(to gain: AUValue) {
        outputFader.$leftGain.ramp(to: gain, duration: 0.3)
        outputFader.$rightGain.ramp(to: gain, duration: 0.3)
    }
    
    private func fadeOutAndStop(duration: Float) {
        outputFader.$leftGain.ramp(to: 0, duration: duration)
        outputFader.$rightGain.ramp(to: 0, duration: duration)
        
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + Double(duration)) { [weak self] in
            self?.player.stop()
            self?.masterConductor.endGame()
        }
    }


}
