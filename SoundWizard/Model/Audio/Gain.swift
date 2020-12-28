//
//  Gain.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/24/20.
//

import Foundation

struct Gain {
    var dB: Float
    var percentage: Float {
        Gain.percentage(dB: dB)
    }
    
    init(dB: Float) {
        self.dB = dB
    }
    
    init(percentage: Float) {
        self.dB = Gain.dB(percentage: percentage)
    }
}

// MARK: Conversions

extension Gain {
    static func percentage(dB: Float) -> Float {
        powf(10, dB/10)
    }
    
    static func dB(percentage: Float) -> Float {
        10 * log10(percentage)
    }
}

// MARK: Equatable & Comparable

extension Gain: Equatable, Comparable {
    static func < (lhs: Gain, rhs: Gain) -> Bool {
        lhs.percentage < rhs.percentage
    }
    
    static func == (lhs: Gain, rhs: Gain) -> Bool {
        return lhs.percentage == rhs.percentage
    }
}

extension Gain {
    var valueString: String {
        dB.uiString
    }
    
    var intValueString: String {
        String(Int(dB))
    }
    
    var unitString: String {
        "dB"
    }
}
