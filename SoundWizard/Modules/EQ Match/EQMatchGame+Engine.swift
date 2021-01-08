//
//  EQMatchGame+Engine.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/7/21.
//

import Foundation

extension EQMatchGame {
    class Engine {
        typealias Filters = [EQBellFilterData]
        typealias TurnData = (solution: Filters, baseGuess: Filters)
        
        private var level: EQMatchLevel
        
        init(level: EQMatchLevel) {
            self.level = level
        }
        
        func newTurn() -> TurnData {
            let normalled = level.normalledFilterData
            let solution = shuffle(normalled)
            let base = baseGuess(normalled: normalled, solution: solution)
            
            return TurnData(solution: solution, baseGuess: base)
        }
        
        private func shuffle(_ data: Filters) -> Filters {
            var solution = data
            for (i, _) in solution.enumerated() {
                solution[i].gain.dB = randomGain()
                solution[i].frequency = randomFrequency(for: solution[i],
                                                          prev: solution[safe: i-1])
            }
            
            return solution
        }
        
        private func baseGuess(normalled: Filters, solution: Filters) -> Filters {
            normalled.enumerated().map { (index, filter) in
                var filter = filter
                
                switch level.format.mode {
                case .fixedGain:
                    let gain = solution[index].gain
                    filter.gain = gain
                    filter.dBGainRange = gain.dB...gain.dB
                default:
                    break
                }
                
                return filter
            }
        }
    }
}

// MARK: - Random Generators

extension EQMatchGame.Engine {
    private func randomGain() -> Double {
        let exclusion = level.format.mode == .fixedFrequency ? 0 : nil
        return Double.randomInt(in: level.gainRange, excluding: exclusion)
    }
    
    private func randomFrequency(for filter: EQBellFilterData,
                                   prev: EQBellFilterData?) -> Frequency {
        guard level.frequencyVariesPerTurn else { return filter.frequency }
        
        // Setup freq range to ensure adjacent bands have enough distance
        var range = filter.frequencyRange
        if let prevFreq = prev?.frequency,
           range.contains(prevFreq) {
            let octave = EQMatchGame.Parameters.minOctaveDistanceBetweenSolutionFrequencies
            let lowerBound = prevFreq.addingOctave(octave)
            range = lowerBound...range.upperBound
        }
        
        let freq = Frequency.random(in: range, repelEdges: true).uiRounded
        return freq
    }
}
