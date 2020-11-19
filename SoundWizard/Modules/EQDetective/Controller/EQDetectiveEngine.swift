//
//  EQDetectiveEngine.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/28/20.
//

import UIKit

protocol EQDetectiveEngineDelegate: class {
    func roundDidBegin()
    func turnDidBegin(turn: EQDetectiveTurn)
    func turnDidEnd(score: EQDetectiveTurnScore)
    func roundDidEnd(round: EQDetectiveRound)
}

enum EQDetectiveGameState {
    case notStarted, awaitingGuess, showingResults, endOfRound
}

class EQDetectiveEngine {
    
    // MARK: - Properties
    
    // MARK: Internal
    
    weak var delegate: EQDetectiveEngineDelegate?
    var level: EQDetectiveLevel
    var currentRound: EQDetectiveRound?
    var currentTurn: EQDetectiveTurn? { currentRound?.currentTurn }
    var isTurnStarted: Bool {
        guard let turn = currentTurn else { return false }
        return !turn.isComplete
    }
    
    // MARK: Private
    
    private var conductor: EqualizerFilterConductor
    private var hapticGenerator: HapticGenerator
    
    // MARK: - Initializers
    
    init(level: EQDetectiveLevel) {
        self.level = level
        hapticGenerator = HapticGenerator.main
        conductor = EqualizerFilterConductor(source: level.audioSource)
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func startNewRound() {
        currentRound = EQDetectiveRound(level: level)
        
        updateConductor(for: level)
        
        delegate?.roundDidBegin()
        
        startNewTurn()
        
        playAudio()
    }
    
    func startNewTurn() {
        guard let round = currentRound else { return }
        
        let turn = round.newTurn()
        updateConductor(with: turn)
        delegate?.turnDidBegin(turn: turn)
    }
    
    func submitGuess(_ freqGuess: Float) {
        guard let round = currentRound,
              let turn = currentTurn else { return }
        
        round.endTurn(freqGuess: freqGuess)
        delegate?.turnDidEnd(score: turn.score!)
        
        fireHaptics(for: turn.score!)
        
        if round.isComplete {
            level.updateProgress(round: round)
            delegate?.roundDidEnd(round: round)
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
    
    func fireHaptics(for score: EQDetectiveTurnScore) {
        hapticGenerator.fire(successLevel: score.successLevel)
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
