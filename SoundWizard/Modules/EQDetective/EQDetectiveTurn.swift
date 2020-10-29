//
//  EQDetectiveTurn.swift
//  AudioKitExperiments
//
//  Created by Wes Moore on 10/28/20.
//

import Foundation

class EQDetectiveTurn {
    var number: Int
    var freqSolution: Float
    var startTime: Date
    var octaveErrorRange: Float
    
    var freqGuess: Float?
    var score: Float = 0.0
    var timeToComplete: TimeInterval?
    var octaveError: Float = 0.0
    
    var isComplete: Bool {
        return freqGuess != nil
    }
    
    init(number: Int, freqSolution: Float, octaveErrorRange: Float) {
        self.number = number
        self.freqSolution = freqSolution
        self.octaveErrorRange = octaveErrorRange
        startTime = Date()
    }
    
    func finish(freqGuess: Float) {
        self.freqGuess = freqGuess
        timeToComplete = Date().timeIntervalSince(startTime)
        octaveError = AudioCalculator.octave(fromFreq: freqGuess, baseOctaveFreq: freqSolution)
        let absError = abs(octaveError)
        if octaveError == 0 {
            score = 100.0
        } else if absError <= octaveErrorRange {
            score = 100.0 * (octaveErrorRange - absError) / octaveErrorRange
        }
    }
}
