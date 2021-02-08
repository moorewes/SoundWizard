//
//  Gain.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/24/20.
//

import Foundation

struct Gain {
    var dB: Double
    var percentage: Double {
        Gain.percentage(dB: dB)
    }
    var auValue: Float {
        Float(percentage)
    }
    
    init(dB: Double) {
        self.dB = dB
    }
    
    init(percentage: Double) {
        self.dB = Gain.dB(percentage: percentage)
    }
    
    static let unity = Gain(dB: 0)
}

// MARK: Conversions

extension Gain {
    static func percentage(dB: Double) -> Double {
        pow(10, dB/10)
    }
    
    static func dB(percentage: Double) -> Double {
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
