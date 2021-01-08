//
//  EQBellFilterData.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/24/20.
//

import Foundation

struct EQBellFilterData {
    var frequency: Frequency
    var gain: Gain
    var q: Double
    
    var frequencyRange: FrequencyRange = BandFocus.all.range
    var dBGainRange: ClosedRange<Double> = -12...12
    
    var roundingFreqs: EQBellFilterData {
        var data = self
        data.frequency = data.frequency.uiRounded
        return data
    }
}

extension EQBellFilterData: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(frequency)
        hasher.combine(frequencyRange)
    }
}

extension Array where Element == EQBellFilterData {
    var frequencyRange: FrequencyRange {
        guard self.isNotEmpty else { return BandFocus.all.range }
        let lower = map { $0.frequencyRange.lowerBound }.sorted().first!
        let upper = map { $0.frequencyRange.upperBound }.sorted().last!
        
        return lower...upper
    }
    
    var gainRange: ClosedRange<Double> {
        guard self.isNotEmpty else { return 0...0 }
        let lower = map { $0.dBGainRange.lowerBound }.sorted().first!
        let upper = map { $0.dBGainRange.upperBound }.sorted().last!
        
        return lower...upper
    }
    
    var roundingFreqs: [EQBellFilterData] {
        map { $0.roundingFreqs }
    }
}
