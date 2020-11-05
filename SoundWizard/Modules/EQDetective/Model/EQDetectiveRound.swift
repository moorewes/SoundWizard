//
//  EQDetectiveRound.swift
//  AudioKitExperiments
//
//  Created by Wes Moore on 10/27/20.
//

import Foundation

class EQDetectiveRound: Round {
        
    // MARK: - Types
    
    // MARK: - Properties
    
    // MARK: Internal
    
    var level: EQDetectiveLevel
    var turns = [EQDetectiveTurn]()
    
    var isComplete: Bool { turns.count == level.numberOfTurns }
    var currentTurnNumber: Int { turns.count + 1 }
    var currentTurn: EQDetectiveTurn { turns.last! }
    
    var averageOctaveError: Float?
    var score: Float = 0
    
    // MARK: Private
    
    
    // MARK: - Initializers
    
    init(level: EQDetectiveLevel) {
        self.level = level
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func newTurn() -> EQDetectiveTurn {
        let freq = AudioCalculator.randomFreq(disfavoring: turns.last?.freqSolution)
        let turn = EQDetectiveTurn(number: turns.count,
                                   freqSolution: freq,
                                   octaveErrorRange: level.octaveErrorRange)
        turns.append(turn)
        return turn
    }
    
    func endTurn(freqGuess: Float) {
        currentTurn.finish(freqGuess: freqGuess)
        score += currentTurn.score!.value
    }

}


