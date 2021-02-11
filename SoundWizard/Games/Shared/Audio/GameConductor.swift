//
//  GameConductor.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import Foundation
import AudioKit

protocol GameConductor {
    var outputFader: Fader? { get }
    func startPlaying()
    func stopPlaying()
}

class SinglePlayerGameConductor: GameConductor {
    // MARK: - Properties
    
    // MARK: Internal
    let masterConductor = Conductor.master
    var outputFader: Fader?
    let player: AudioPlayer
    let audio: [AudioMetadata]
    let rampTime: AUValue = 0.05
    
    lazy var playerGain: AUValue = Gain(dB: -12).auValue
    
    // MARK: Private
    
    private let dimVolume = AUValue(Gain.percentage(dB: -6))
    
    // MARK: - Initializers
    
    init(audio: [AudioMetadata]) {
        self.audio = audio
        self.player = AudioPlayer(url: audio[0].url, buffered: true)!
                
        player.volume = playerGain
    }
        
    // MARK: Internal Methods
    func startPlaying() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.setupPlayer()
            self.player.start()
            self.fadeIn()
        }
    }
    
    func setupPlayer() {
        player.isLooping = true
    }
    
    func changeAudio() {
        let buffer = audio.shuffled()[0].buffer
        player.buffer = buffer
    }
        
    func stopPlaying() {
        fadeOutAndStop(duration: 1.5)
    }
    
    func mute(_ muted: Bool) {
        if muted {
            fadeOut()
        } else {
            fadeIn()
        }
    }
    
    func setDim(dimmed: Bool) {
        let gain = dimmed ? dimVolume : 1
        
        outputFader?.$leftGain.ramp(to: gain, duration: 0.3)
        outputFader?.$rightGain.ramp(to: gain, duration: 0.3)
    }
    
    // MARK: Private Methods
    private func fadeIn() {
        fade(fadeIn: true)
    }
    
    private func fadeOut() {
        fade(fadeIn: false)
    }
    
    private func fade(fadeIn: Bool) {
        let gain: AUValue = fadeIn ? 1 : 0
        
        outputFader?.$leftGain.ramp(to: gain, duration: 0.3)
        outputFader?.$rightGain.ramp(to: gain, duration: 0.3)
    }
    
    private func fadeOutAndStop(duration: Float) {
        outputFader?.$leftGain.ramp(to: 0, duration: duration)
        outputFader?.$rightGain.ramp(to: 0, duration: duration)
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(duration)) { [weak self] in
            self?.tearDown()
        }
    }
    
    private func tearDown() {
        player.stop()
        player.buffer = nil
        player.reset()

        outputFader = nil
        
        masterConductor.endGame()
    }
}
