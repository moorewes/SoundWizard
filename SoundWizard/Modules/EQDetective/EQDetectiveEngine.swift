//
//  EQDetectiveEngine.swift
//  AudioKitExperiments
//
//  Created by Wes Moore on 10/28/20.
//

import Foundation

class EQDetectiveEngine {
    
    // MARK: - Properties
    
    // MARK: Internal
    
    var currentRound: EQDetectiveRound?
    var currentTurn: EQDetectiveTurn? { return currentRound?.currentTurn }
    
    // MARK: Private
    
    private var conductor: EqualizerFilterConductor
    private var vc: EQDetectiveViewController
    
    // MARK: - Initializers
    
    init(vc: EQDetectiveViewController) {
        self.vc = vc
        conductor = EqualizerFilterConductor()
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func startNewRound() {
        let roundData = EQDetectiveRoundData()
        currentRound = EQDetectiveRound(roundData: roundData)
        
        updateConductor(with: roundData)
        
        vc.roundDidBegin(roundData: roundData)
        
        startNewTurn()
        
        playAudio()
    }
    
    func startNewTurn() {
        guard let round = currentRound else { return }
        
        let turn = round.newTurn()
        updateConductor(with: turn)
        vc.turnDidBegin(turn: turn)
    }
    
    func submitGuess(_ freqGuess: Float) {
        guard let round = currentRound,
              let turn = currentTurn else { return }
        
        round.endTurn(freqGuess: freqGuess)
        
        vc.turnDidEnd(roundScore: round.roundData.score,
                      turnScore: turn.score!,
                      octaveError: turn.octaveError)
        
        if round.isComplete {
            vc.roundDidEnd(round: round)
        }
    }
    
    func toggleMute(mute: Bool) {
        if mute {
            pauseAudio()
        } else {
            playAudio()
        }
    }
    
    func toggleFilter(bypass: Bool) {
        guard let gain = bypass ? 1 : currentRound?.roundData.filterGain else { return }
        conductor.set(filterGain: gain)
    }
    
    func previewFreq(_ freq: Float) {
        conductor.set(filterFreq: freq)
    }
    
    // MARK: Private
    
    private func updateConductor(with roundData: EQDetectiveRoundData) {
        conductor.set(filterQ: roundData.filterQ)
        conductor.set(filterGain: roundData.filterGain)
    }
    
    private func updateConductor(with turn: EQDetectiveTurn) {
        conductor.set(filterFreq: turn.freqSolution)
    }
    
    private func playAudio() {
        conductor.startPlaying()
    }
    
    private func stopAudio() {
        conductor.stopPlaying()
    }
    
    private func pauseAudio() {
        conductor.pausePlaying()
    }
    
}
