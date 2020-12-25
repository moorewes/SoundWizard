//
//  EQMatchConductor.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import Foundation
import AudioKit
import AVFoundation

class EQMatchConductor: GameConductor {
    
    // MARK: - Shared Instance
        
    // MARK: - Properties
    
    // MARK: Internal
    
    var outputFader: Fader
    
    lazy var playerGain: AUValue = Gain.percentage(dB: -8)

        
    // MARK: Private
    private let conductor = Conductor.master
    private let player = AudioPlayer()
    private var filters = [EqualizerFilter]()
    private var filterData: [EQBellFilterData]
    private let buffer: AVAudioPCMBuffer
    private var dryFader: Fader!
    private var wetFader: Fader!
    private var mixer: Mixer!
    
    private let rampTime: AUValue = 0.05
    private let dimVolume: AUValue = Gain.percentage(dB: -6)
    
    // MARK: - Initializers
    
    init(source: AudioMetadata, filterData: [EQBellFilterData]) {
        self.buffer = Cookbook.buffer(for: source.url)
        self.filterData = filterData
        self.outputFader = Fader(player)
        for data in filterData {
            let filter = EqualizerFilter(filters.last ?? player)
            update(filter: filter, with: data)
            filters.append(filter)
        }
        wetFader = Fader(filters.last ?? player, gain: 1)
        dryFader = Fader(player, gain: 0)
        mixer = Mixer([dryFader, wetFader])
        outputFader = Fader(wetFader, gain: 0)
                
        player.volume = playerGain
        conductor.patchIn(self)
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func startPlaying() {
        player.scheduleBuffer(buffer, at: nil, options: .loops)
        player.start()
        fadeIn()
    }
        
    func stopPlaying() {
        fadeOutAndStop(duration: 2)
    }
    
    func mute(_ muted: Bool) {
        if muted {
            fadeOut()
        } else {
            fadeIn()
        }
    }
    
    func setFilterBypass(_ bypass: Bool) {
        let dryGain: AUValue = bypass ? 1 : 0
        [dryFader.$leftGain, dryFader.$rightGain].forEach { $0.ramp(to: dryGain, duration: rampTime)}
        
        let wetGain: AUValue = bypass ? 0 : 1
        [wetFader.$leftGain, wetFader.$rightGain].forEach { $0.ramp(to: wetGain, duration: rampTime)}
    }
    
    func setDim(dimmed: Bool) {
        let gain = dimmed ? dimVolume : 1
        
        outputFader.$leftGain.ramp(to: gain, duration: 0.3)
        outputFader.$rightGain.ramp(to: gain, duration: 0.3)
    }
    
    func update(data: [EQBellFilterData]) {
        self.filterData = data
        for (index, data) in filterData.enumerated() {
            update(filter: filters[index], with: data)
        }
    }
    
    func update(filter: EqualizerFilter, with data: EQBellFilterData) {
        filter.$centerFrequency.ramp(to: data.frequency, duration: rampTime)
        filter.$bandwidth.ramp(to: data.frequency / data.q, duration: rampTime)
        filter.$gain.ramp(to: data.gain.percentage, duration: rampTime)
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
            self?.conductor.endGame()
        }
    }
}

