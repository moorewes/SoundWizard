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
    
    func stopPlaying(fade: Bool)
        
}

class EQDetectiveConductor: GameConductor {
    
    // MARK: - Shared Instance
        
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
    private let conductor = Conductor.shared
    private let player = AudioPlayer()
    private let filter: EqualizerFilter
    private let buffer: AVAudioPCMBuffer
    private let filterRampTime: AUValue = 0.05
    private let dimVolume: AUValue = AudioMath.dBToPercent(dB: -6)

    
    // MARK: - Initializers
    
    init(source: AudioSource,
         filterGainDB: AUValue,
         filterQ: AUValue) {
        print(source.url.description)
        buffer = Cookbook.buffer(for: source.url)
        self.filterGainDB = filterGainDB
        self.filterQ = filterQ

        filter = EqualizerFilter(player)
        filter.centerFrequency = 1000
        filter.gain = 1
        filter.bandwidth = 1000
        
        outputFader = Fader(filter, gain: 0)
                
        player.volume = volume
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func startPlaying() {
        conductor.start(with: self)
        player.scheduleBuffer(buffer, at: nil, options: .loops)
        player.start()
        fadeIn()
    }
        
    func stopPlaying(fade: Bool) {
        if fade {
            fadeOutAndStop(duration: 2)
        } else {
            player.stop()
        }
        
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
    
    private func fadeIn() {
        fade(fadeIn: true)
    }
    
    private func fadeOut() {
        fade(fadeIn: false)
    }
    
    private func fade(fadeIn: Bool) {
        let gain: AUValue = fadeIn ? 1 : 0
        
        outputFader.$leftGain.ramp(to: gain, duration: 0.3)
        outputFader.$rightGain.ramp(to: gain, duration: 0.3)
    }
    
    private func fadeOutAndStop(duration: Float) {
        outputFader.$leftGain.ramp(to: 0, duration: duration)
        outputFader.$rightGain.ramp(to: 0, duration: duration)
        DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + Double(duration)) { [weak self] in
            self?.player.stop()
            self?.conductor.stop()
        }
    }


}
