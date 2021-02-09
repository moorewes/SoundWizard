//
//  GainBrainGame+Engine.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import Foundation

extension GainBrainGame {
    struct Engine {
        func newTurn(number: Int, choicesCount: Int) -> Turn {
            let solution = newSolution()
            let choices = allChoices(solution: solution, count: choicesCount)
            return Turn(number: number, solution: solution, choices: choices)
        }
        
        private func newSolution() -> Turn.Solution {
            Turn.Solution(gain: randomGainValue())
        }
        
        private func randomGainValue() -> Double {
            let index = Int.random(in: 0..<Turn.Solution.possibleGainValues.count)
            return Turn.Solution.possibleGainValues[index]
        }
        
        private func allChoices(solution: Turn.Solution, count: Int) -> [Turn.Choice] {
            var result: [Turn.Choice] = [solution]
            while result.count < count {
                let gain = randomGainValue()
                guard gain != solution.gain else { continue }
                result.append(Turn.Choice(gain: gain))
            }
            result.shuffle()
            return result
        }
    }
}
