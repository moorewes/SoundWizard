//
//  AudioCalculator.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/26/20.
//

import Foundation

struct AudioCalculator {
    
    // MARK: - Static Methods
    
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
    
    static func randomFreq(in range: ClosedRange<Float>, disfavoring disfavoredFreq: Float? = nil) -> Float {
        let octaveRange = AudioCalculator.octaveRange(freqRange: range)
        var octave = randomOctave(in: octaveRange)
        
        // Weaken chances of frequencies close to edges
        if octave < 3.0 || octave > 9.0 {
            let i = Int.random(in: 0...5)
            if i < 4 {
                octave = randomOctave(in: octaveRange)
            }
        }
        
        // Weaken chance of frequencies close to disfavored
        if let avoidFreq = disfavoredFreq {
            if abs(octave - Self.octave(fromFreq: avoidFreq)) < 0.3 {
                let i = Int.random(in: 0...5)
                if i < 5 {
                    octave = randomOctave(in: octaveRange)
                }
            }
        }
        
        return AudioCalculator.freq(fromOctave: octave)
    }
    
    static func randomOctave(in range: ClosedRange<Float>) -> Float {
        let multiplier: Float = 1000.0
        let minBound = Int(range.lowerBound * multiplier)
        let maxBound = Int(range.upperBound * multiplier)
        let intRange = minBound...maxBound
        let random = Int.random(in: intRange)
        
        return Float(random) / multiplier
    }
    
    private static func octaveRange(freqRange: ClosedRange<Float>) -> ClosedRange<Float> {
        let lowerBound = AudioCalculator.octave(fromFreq: freqRange.lowerBound)
        let upperBound = AudioCalculator.octave(fromFreq: freqRange.upperBound)
        return lowerBound...upperBound
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
