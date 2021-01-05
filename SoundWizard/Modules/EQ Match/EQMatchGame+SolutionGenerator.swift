//
//  EQMatchGame+SolutionGenerator.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/4/21.
//

import Foundation

extension EQMatchGame {
    class SolutionGenerator {
        typealias Solution = [EQBellFilterData]
        
        // MARK: - Constants
        
        let fullGainRange = -9.0...9.0
        
        private let easyGainRange = 4.0...9.0
        private let moderateGainRange = 1.0...9.0
        private let minOctaveDistanceBetweenSolutionFrequencies = 0.5
        private let filterQ = 2.0
                
        // MARK: - Private Properties
        
        private var level: EQMatchLevel
        private var bandCount: Int {
            level.format.bandCount.rawValue
        }
        
        // MARK: - Initialization
                
        init(level: EQMatchLevel) {
            self.level = level
        }
        
        // MARK: - Internal Usage
        
        lazy var solutionTemplate: Solution = {
            Array(0..<bandCount).map { index in
                EQBellFilterData(
                    frequency: templateFrequency(filterNumber: index),
                    gain: templateGain(),
                    q: filterQ,
                    frequencyRange: frequencyRange(filterNumber: index),
                    dBGainRange: gainRange
                )
            }
        }()
        
        func nextSolution() -> Solution {
            var solution = solutionTemplate
            for (i, _) in solution.enumerated() {
                solution[i].gain.dB = randomGain()
                solution[i].frequency = shuffledFrequency(for: solution[i],
                                                          prevFilter: solution[safe: i-1])
            }
            
            return solution
        }
        
        // MARK: - Private Helpers
        
       // MARK: Template Helper Methods
        
        func templateFrequency(filterNumber: Int) -> Frequency {
            if let staticFreqs = level.staticFrequencies,
               staticFreqs.count == bandCount {
                return staticFreqs[filterNumber]
            }
            
            let percentage = Double(filterNumber) / Double(bandCount) + 0.5 / Double(bandCount)
            let freq = AudioMath.frequency(percent: percentage,
                                           in: level.format.bandFocus.range,
                                           uiRounded: true)
            return freq
        }
        
        private func templateGain() -> Gain {
            gainRange.lowerBound < 0 ? Gain.unity : Gain(dB: gainRange.lowerBound)
        }
        
        private lazy var gainRange: ClosedRange<Double> = {
            switch level.difficulty {
            case .easy:
                if level.format.mode == .fixedFrequency {
                    return 0...easyGainRange.upperBound
                } else {
                    return easyGainRange
                }
            case .moderate:
                if level.format.mode == .fixedFrequency {
                    return 0...moderateGainRange.upperBound
                } else {
                    return moderateGainRange
                }
            case .hard, .custom:
                return fullGainRange
            }
        }()
        
        private func frequencyRange(filterNumber: Int) -> FrequencyRange {
            if level.format.mode == .fixedFrequency {
                let freq = templateFrequency(filterNumber: filterNumber)
                return freq...freq
            }
            let startPercentage = Double(filterNumber) / Double(bandCount)
            let endPercentage = Double(filterNumber + 1) / Double(bandCount)
            let startFreq = AudioMath.frequency(percent: startPercentage, in: level.format.bandFocus.range)
            let endFreq = AudioMath.frequency(percent: endPercentage, in: level.format.bandFocus.range)
            
            return startFreq...endFreq
        }
        
        // MARK: Random Solution Helper Methods

        private func randomGain() -> Double {
            let exclusion = level.format.mode == .fixedFrequency ? 0 : nil
            return Double.randomInt(in: gainRange, excluding: exclusion)
        }
        
        private func shuffledFrequency(for filter: EQBellFilterData,
                                       prevFilter: EQBellFilterData?) -> Frequency {
            guard level.variesFrequency else { return filter.frequency }
            
            // Setup freq range to ensure adjacent bands have enough distance
            var range = filter.frequencyRange
            if let prevFreq = prevFilter?.frequency,
               range.contains(prevFreq) {
                let lowerBound = AudioMath.freq(
                    fromOctave: minOctaveDistanceBetweenSolutionFrequencies,
                    baseOctaveFreq: prevFreq
                )
                range = lowerBound...range.upperBound
            }
            
            let freq = Frequency.random(in: range, repelEdges: true)
            return freq
        }
    }
}
