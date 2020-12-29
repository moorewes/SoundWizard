//
//  EQDetectiveTurn.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/28/20.
//

import Foundation

struct EQDetectiveTurn: GameTurn {
    
    let number: Int
    let octaveErrorRange: Octave // TODO: Use double and rename
    let solution: Frequency
    let scoreMultiplier: Double
    
    private var startTime = Date()
    private(set) var completionTime: TimeInterval?
    private(set) var guess: Frequency?
    private(set) var score: Score?
    private(set) var octaveError: Double?
    
    var isComplete: Bool { guess != nil }
    
    init(number: Int, octaveErrorRange: Octave, solution: Frequency, scoreMultiplier: Double) {
        self.number = number
        self.octaveErrorRange = octaveErrorRange
        self.solution = solution
        self.scoreMultiplier = scoreMultiplier
    }

    mutating func finish(guess: Frequency) {
        self.guess = guess
        completionTime = Date().timeIntervalSince(startTime)
        score = score(for: octaveError!)
    }
    
    mutating private func score(for guess: Frequency) -> Score {
        var score = ScoreEngine.score(guess: guess, solution: solution, maxOctaveError: Double(octaveErrorRange))
        score.value *= scoreMultiplier
        
        return score
    }
    
}


