//
//  AudioCalculator.swift
//  AudioKitExperiments
//
//  Created by Wes Moore on 10/26/20.
//

import Foundation

struct AudioCalculator {
    
    /// Octave in relation to the base octave given the frequency
    static func octave(fromFreq freq: Float, baseOctaveFreq: Float = 20, decimalPlaces: Int = 1) -> Float {
        var octave = logf(freq / baseOctaveFreq) / logf(2.0)
        octave.roundToPlaces(places: decimalPlaces)
        
        return octave
    }
    
    /// Frequency in Hz given the octave, where 0 = 20Hz, 1 = 40Hz, -1 = 10Hz, etc..
    static func freq(fromOctave octave: Float, baseOctaveFreq: Float = 20, rounded: Bool = true) -> Float {
        var freq = baseOctaveFreq * powf(2, octave)
        if rounded {
            freq = roundedFreq(freq)
        }
        
        return freq
    }
    
    static func roundedFreq(_ freq: Float) -> Float {
        var freq = freq
        if freq < 200 {
            freq = freq.rounded(to: 1)
        } else if freq < 500 {
            freq = freq.rounded(to: 5)
        } else if freq < 1000 {
            freq = freq.rounded(to: 10)
        } else {
            freq = freq.rounded(to: 100)
        }
        return freq
    }
    
    static func dBToPercent(dB: Float) -> Float {
        return powf(10, dB/10)
    }
    
    static func randomFreq() -> Float {
        let octave = Float(Int.random(in: 10...100)) / 10.0
        return AudioCalculator.freq(fromOctave: octave)
    }
    
}

fileprivate extension Float {
    
    mutating func roundToPlaces(places: Int) {
        let divisor = pow(10.0, Float(places))
        self = (self * divisor).rounded() / divisor
    }
}

extension FloatingPoint {
    func rounded(to value: Self, roundingRule: FloatingPointRoundingRule = .toNearestOrAwayFromZero) -> Self {
       (self / value).rounded(roundingRule) * value
    }
}
