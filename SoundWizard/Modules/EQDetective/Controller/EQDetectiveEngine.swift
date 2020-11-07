//
//  EQDetectiveEngine.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/28/20.
//

import Foundation

class EQDetectiveEngine {
    
    // MARK: - Properties
    
    // MARK: Internal
    
    var level: EQDetectiveLevel
    var currentRound: EQDetectiveRound?
    var currentTurn: EQDetectiveTurn? { currentRound?.currentTurn }
    
    // MARK: Private
    
    private var conductor: EqualizerFilterConductor
    private weak var vc: EQDetectiveViewController?
    
    // MARK: - Initializers
    
    init(vc: EQDetectiveViewController? = nil, level: EQDetectiveLevel) {
        self.vc = vc
        self.level = level
        conductor = EqualizerFilterConductor(source: level.audioSource)
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func startNewRound() {
        currentRound = EQDetectiveRound(level: level)
        
        updateConductor(for: level)
        
        vc?.roundDidBegin(level: level)
        
        startNewTurn()
        
        playAudio()
    }
    
    func startNewTurn() {
        guard let round = currentRound else { return }
        
        let turn = round.newTurn()
        updateConductor(with: turn)
        vc?.turnDidBegin(turn: turn)
    }
    
    func submitGuess(_ freqGuess: Float) {
        guard let round = currentRound,
              let turn = currentTurn else { return }
        
        round.endTurn(freqGuess: freqGuess)
        
        vc?.turnDidEnd(turn: turn, turnScore: turn.score!, roundScore: round.score)
        
        if round.isComplete {
            vc?.roundDidEnd(round: round)
        }
    }
    
    func toggleMute(mute: Bool) {
        conductor.mute(mute)
    }
    
    func toggleFilter(bypass: Bool) {
        guard let gain = bypass ? 1 : currentRound?.level.filterGainDB else { return }
        conductor.set(filterGainDB: gain)
    }
    
    func previewFreq(_ freq: Float) {
        conductor.set(filterFreq: freq)
    }
    
    func stop() {
        stopAudio()
    }
    
    // MARK: Private
    
    private func updateConductor(for level: EQDetectiveLevel) {
        conductor.set(filterQ: level.filterQ)
        conductor.set(filterGainDB: level.filterGainDB)
    }
    
    private func updateConductor(with turn: EQDetectiveTurn) {
        toggleFilter(bypass: true)
        conductor.set(filterFreq: turn.freqSolution)
        toggleFilter(bypass: false)
    }
    
    private func playAudio() {
        conductor.startPlaying()
    }
    
    private func stopAudio() {
        conductor.stopPlaying()
    }
    
}
