//
//  EQMatchLevel+Parameters.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/7/21.
//

import Foundation

// MARK: Normalled Filter Data

extension EQMatchLevel {
    var normalledFilterData: [EQBellFilterData] {
        Array(0..<bandCount).map { index in
            EQBellFilterData(
                frequency: normalledFreq(filterIndex: index),
                gain: normalledGain,
                q: EQMatchGame.Parameters.filterQ,
                frequencyRange: frequencyRange(filterIndex: index),
                dBGainRange: gainRange
            )
        }
    }
}

// MARK: Filter Gain Data

extension EQMatchLevel {
    var normalledGain: Gain {
        gainRange.lowerBound < 0 ? Gain.unity : Gain(dB: gainRange.lowerBound)
    }
    
    var gainRange: ClosedRange<Double> {
        switch (difficulty, format.mode) {
        case (.easy, .fixedFrequency):
            return 0.0...EQMatchGame.Parameters.positiveGainRange.upperBound
        case (.easy, _):
            return EQMatchGame.Parameters.easiestGainRange
        case (.moderate, .fixedFrequency):
            return EQMatchGame.Parameters.fullGainRange
        case (.moderate, _):
            return EQMatchGame.Parameters.positiveGainRange
        case (.hard, _):
            return EQMatchGame.Parameters.fullGainRange
        default:
            return EQMatchGame.Parameters.fullGainRange
        }
    }
}

// MARK: Filter Frequency Formats

extension EQMatchLevel {
    var bandCount: Int {
        format.bandCount.rawValue
    }
    
    var frequencyVariesPerTurn: Bool {
        format.mode != .fixedFrequency ||
            difficulty >= .moderate
    }
    
    var frequencyRange: FrequencyRange {
        format.bandFocus.range
    }
    
    func normalledFreq(filterIndex: Int) -> Frequency {
        if let staticFreqs = staticFrequencies,
           staticFreqs.count == bandCount {
            return staticFreqs[filterIndex]
        }
        
        let percentage = Double(filterIndex) / Double(bandCount) + 0.5 / Double(bandCount)
        let freq = AudioMath.frequency(percent: percentage,
                                       in: frequencyRange,
                                       uiRounded: true)
        return freq
    }
    
    func frequencyRange(filterIndex: Int) -> FrequencyRange {
        if format.mode == .fixedFrequency {
            let freq = normalledFreq(filterIndex: filterIndex)
            return freq...freq
        }
        
        let startPercentage = Double(filterIndex) / Double(bandCount)
        let endPercentage = Double(filterIndex + 1) / Double(bandCount)
        let startFreq = AudioMath.frequency(percent: startPercentage, in: frequencyRange)
        let endFreq = AudioMath.frequency(percent: endPercentage, in: frequencyRange)
        
        return startFreq...endFreq
    }
}
