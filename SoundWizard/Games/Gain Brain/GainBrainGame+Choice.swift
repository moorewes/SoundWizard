//
//  GainBrainGame+Turn.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import Foundation

// MARK: - Choice
extension GainBrainGame {
    struct Choice: MultipleChoiceGameChoice {
        var gain: Double
        var isCorrect: Bool = false
        
        var title: String { "\(Int(gain)) dB" }
        var id: String { title }
    }
}

// MARK: - Choice Generator
extension GainBrainGame  {
    struct ChoiceGenerator {
        static let possibleGainValues: [Double] = [
            -18, -16, -14, -12, -9, -6, -4, -3, -2, -1, 0, 1, 2, 3, 4, 6
        ]
        
        static let choicesCount = 2
        
        static func generate(stage: Int) -> [Choice] {
            // Pick a random solution
            let solutionIndex = Int.random(in: 0..<possibleGainValues.count)
            let solutionGain = possibleGainValues[solutionIndex]
            let solution = Choice(gain: solutionGain, isCorrect: true)
            
            // Get possible choice indices and shuffle
            let range = distanceRange(stage: stage)
            let indexOptions = possibleGainValues.indices.filter {
                range.contains(abs($0 - solutionIndex)) &&
                    (possibleGainValues[$0] < 0) == (solutionGain < 0)
            }.shuffled()
            
            // Choose the remaining choices at random
            let choiceIndices = indexOptions.prefix(choicesCount - 1)
            let choices = choiceIndices.map { Choice(gain: possibleGainValues[$0]) }
            
            return [solution] + choices.shuffled()
        }
        
        private static func distanceRange(stage: Int) -> ClosedRange<Int> {
            switch stage {
            case 0:
                return 2...6
            case 1:
                return 2...5
            case 2:
                return 1...4
            case 3:
                return 1...3
            default:
                return 1...2
            }
        }
    }
}
