//
//  AUBellFilterData.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/28/20.
//

import Foundation

struct AUBellFilterData {
    var frequency: Float
    var gain: Float
    var q: Float
    
    init(data: EQBellFilterData) {
        self.frequency = Float(data.frequency)
        self.gain = Float(data.gain.percentage)
        self.q = Float(data.q)
    }
}

extension Array where Element == EQBellFilterData {
    var auData: [AUBellFilterData] {
        self.map { AUBellFilterData(data: $0) }
    }
}
