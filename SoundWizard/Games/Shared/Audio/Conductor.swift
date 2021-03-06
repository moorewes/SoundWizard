//
//  GameConductor.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/3/20.
//

import AVFoundation
import AudioKit

class Conductor {
    // MARK: - Shared Instance
    
    static let master = Conductor()
    
    // MARK: - Properties
    
    // MARK: Internal
    
    // MARK: Private
    
    private var engine = AudioEngine()
    private let masterFader: Fader
    private let fxManager = SoundFXManager.main
    private let fxPlayer = AudioPlayer()
    private let mixer: Mixer
    private var gameConductor: GameConductor?
    private var volume: AUValue = Gain(dB: -20).auValue
    
    // MARK: - Initializers
    
    init() {
        fxPlayer.volume = volume
        mixer = Mixer([fxPlayer])
        masterFader = Fader(mixer)
        engine.output = masterFader
        start()
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func start() {
        guard !engine.avEngine.isRunning else { return }
        configure()
        
        engine.avEngine.prepare()
        do {
            try engine.start()
        } catch let err {
            print(err)
            fatalError("couldn't start engine")
        }
    }
    
    func stop() {
        guard engine.avEngine.isRunning else { return }
        engine.stop()
    }
    
    func pauseEngine() {
        self.engine.avEngine.pause()
    }
    
    func endGame() {
        disconnectGameConductor()
    }
    
    func patchIn(_ gameConductor: GameConductor) {
        mixer.addInput(gameConductor.outputFader!) // TODO: Remove !
        self.gameConductor = gameConductor
        start()
    }
    
    func fireScoreFeedback(successLevel: ScoreSuccess) {
        let buffer = fxManager.buffer(for: successLevel)
        play(buffer)
    }
    
    func fireWinStarFeedback(star: Int) {
        if !engine.avEngine.isRunning {
            start()
        }
        let buffer = fxManager.buffer(for: star)
        play(buffer)
    }
    
    // MARK: Private
    
    private func configure() {
        do {
            try Settings.setSession(category: .playback)
        } catch {
            print(error.localizedDescription)
        }
        Settings.bluetoothOptions = .allowBluetoothA2DP
    }
    
    private func play(_ buffer: AVAudioPCMBuffer) {
        fxPlayer.stop()
        fxPlayer.buffer = buffer
        fxPlayer.play()
    }
    
    private func fadeOut(completion: @escaping () -> Void) {
        let duration: Float = 0.2
        masterFader.$leftGain.ramp(to: 0, duration: duration)
        masterFader.$rightGain.ramp(to: 0, duration: duration)
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(duration)) {
            completion()
        }
    }
    
    private func disconnectGameConductor() {
        // FIXME: AudioKit bug? Following node removal causes crash, but only
        // when node is a dryWet mixer.
//        if let node = self.gameConductor?.outputFader {
//            mixer.removeInput(node)
//        }
        print("A node should have been removed and released, but wasn't")
        gameConductor = nil
    }    
}

