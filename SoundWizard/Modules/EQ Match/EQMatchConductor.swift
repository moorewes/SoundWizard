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
    
    lazy var playerGain: AUValue = Gain(dB: -12).auValue
        
    // MARK: Private
    private let conductor = Conductor.master
    private let player: AudioPlayer
    private var guessFilters = [EqualizerFilter]()
    private var solutionFilters = [EqualizerFilter]()
    private var guessFilterData: [AUBellFilterData]!
    private var solutionFilterData: [AUBellFilterData]!
    private let buffer: AVAudioPCMBuffer
    private var filterMixer: DryWetMixer!
    
    private let rampTime: AUValue = 0.05
    private let dimVolume = AUValue(Gain.percentage(dB: -6))
    
    // MARK: - Initializers
    
    init(source: AudioMetadata, filterData: [AUBellFilterData]) {
        self.buffer = Cookbook.buffer(for: source.url)
        self.player = AudioPlayer(url: source.url)!
        self.guessFilterData = filterData
        self.solutionFilterData = filterData
        self.outputFader = Fader(player)
        
        for data in filterData {
            let guessFilter = EqualizerFilter(guessFilters.last ?? player)
            let solutionFilter = EqualizerFilter(solutionFilters.last ?? player)
            let filters = [guessFilter, solutionFilter]
            filters.forEach { filter in
                filter.centerFrequency = data.frequency
                filter.gain = data.gain
                filter.bandwidth = data.frequency / data.q
            }
            guessFilters.append(guessFilter)
            solutionFilters.append(solutionFilter)
        }
        
        filterMixer = DryWetMixer(guessFilters.last ?? player, solutionFilters.last ?? player)
        
        outputFader = Fader(filterMixer)
                
        player.volume = playerGain
        conductor.patchIn(self)
    }
    
    deinit {
        print("eq match conductor deinit")
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func startPlaying() {
        player.buffer = buffer
        player.isLooping = true
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(rampTime)) {
            self.player.start()
            self.fadeIn()
        }
        
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
    
    func set(filterMode: EQMatchGame.FilterMode) {
        switch filterMode {
        case .guess:
            filterMixer.balance = 0.0
        case .solution:
            filterMixer.balance = 1.0
        }
    }
    
    func setDim(dimmed: Bool) {
        let gain = dimmed ? dimVolume : 1
        
        outputFader.$leftGain.ramp(to: gain, duration: 0.3)
        outputFader.$rightGain.ramp(to: gain, duration: 0.3)
    }
    
    func update(guess: [AUBellFilterData]) {
        guessFilterData = guess
        for (index, data) in guessFilterData.enumerated() {
            update(filter: guessFilters[index], with: data)
        }
    }
    
    func update(solution: [AUBellFilterData]) {
        solutionFilterData = solution
        for (index, data) in solutionFilterData.enumerated() {
            update(filter: solutionFilters[index], with: data)
        }
    }
    
    func update(filter: EqualizerFilter, with data: AUBellFilterData) {
        filter.$centerFrequency.ramp(to: data.frequency, duration: rampTime)
        filter.$bandwidth.ramp(to: data.frequency / data.q, duration: rampTime)
        filter.$gain.ramp(to: data.gain, duration: rampTime)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(duration)) { [weak self] in
            self?.tearDown()
        }
    }
    
    private func tearDown() {
        player.stop()
        for filter in guessFilters {
            filter.stop()
        }
        for filter in solutionFilters {
            filter.stop()
        }
        
        conductor.endGame()
    }
}

