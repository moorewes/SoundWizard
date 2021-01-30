//
//  EQDetectiveTurn.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/28/20.
//

import Foundation

struct EQDetectiveTurn: GameTurn {
    let number: Int
    let octaveErrorRange: Octave
    let solution: Frequency
    let scoreMultiplier: Double
    
    var isComplete: Bool { guess != nil }
    
    private(set) var guess: Frequency? {
        didSet {
            calculateScore()
        }
    }
    
    private(set) var score: Score?

    init(number: Int, octaveErrorRange: Octave, solution: Frequency, scoreMultiplier: Double) {
        self.number = number
        self.octaveErrorRange = octaveErrorRange
        self.solution = solution
        self.scoreMultiplier = scoreMultiplier
    }

    mutating func finish(guess: Frequency) {
        self.guess = guess
    }
    
    mutating private func calculateScore() {
        guard let guess = guess else { return }
        
        var score = ScoreEngine.score(guess: guess, solution: solution, maxOctaveError: Double(octaveErrorRange))
        score.value *= scoreMultiplier
        
        self.score = score
    }
}
