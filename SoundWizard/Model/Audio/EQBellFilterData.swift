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
    var q: Float
    
    var frequencyRange: FrequencyRange = BandFocus.all.range
    var dBGainRange: ClosedRange<Float> = -12...12
}

extension EQBellFilterData: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(frequency)
        hasher.combine(frequencyRange)
    }
}
