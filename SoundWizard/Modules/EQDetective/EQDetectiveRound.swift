//
//  EQDetectiveRound.swift
//  AudioKitExperiments
//
//  Created by Wes Moore on 10/27/20.
//

import Foundation

class EQDetectiveRound {
    
    // MARK: - Types
    
    // MARK: - Properties
    
    // MARK: Internal
    
    var roundData = EQDetectiveRoundData()
    var turns = [EQDetectiveTurn]()
    var currentTurnNumber: Int { return turns.count + 1 }
    var currentTurn: EQDetectiveTurn { return turns.last! }
    
    // MARK: Private
    
    
    // MARK: - Initializers
    
    init(roundData: EQDetectiveRoundData = EQDetectiveRoundData()) {
        self.roundData = roundData
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func newTurn() -> EQDetectiveTurn {
        let freq = AudioCalculator.randomFreq()
        let turn = EQDetectiveTurn(number: turns.count,
                                   freqSolution: freq,
                                   octaveErrorRange: roundData.octaveErrorRange)
        turns.append(turn)
        return turn
    }
    
    func endTurn(freqGuess: Float) {
        currentTurn.freqGuess = freqGuess
        currentTurn.timeToComplete = Date().timeIntervalSince(currentTurn.startTime)
    }
    
    // MARK: Private
    
    
    
}


