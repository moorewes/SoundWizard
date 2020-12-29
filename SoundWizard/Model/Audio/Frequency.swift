//
//  Frequency.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import Foundation

typealias Frequency = Double
typealias FrequencyRange = ClosedRange<Frequency>

extension Frequency {
    // Self converted to Float for use in AU contexts
    var auValue: Float {
        Float(self)
    }
    
    /// A frequency string with one decimal place and the unit, aka 3.2 kHz or 300 Hz
    var decimalString: String {
        if self / 1000.0 >= 1 {
            return String(format: "%.1f", self / 1000.0)
        } else {
            return "\(Int(self))"
        }
    }
    
    var decimalStringWithUnit: String {
        if self / 1000.0 >= 1 {
            let freqString = String(format: "%.1f", self / 1000.0)
            return freqString + " kHz"
        } else {
            return "\(Int(self)) Hz"
        }
    }
    
    /// Hz if frequency is under 1000, otherwise kHz
    var unitString: String {
        if self / 1000.0 >= 1 {
            return "kHz"
        } else {
            return "Hz"
        }
    }
    
    /// A short frequency string, rounded to one decimal place. Ex: 300, 1k, 1.2k
    var shortString: String {
        if self < 1000 {
            return String(Int(self))
        } else {
            let kValue = (self / 1000).rounded(places: 1)
            if kValue == Double(Int(kValue)) {
                return String(Int(kValue)) + "k"
            } else {
                return String(format: "%.1f", kValue) + "k"
            }
        }
    }
    
    /// Returns, when self is a frequency in Hz, a human-friendly frequency
    /// using a rounding system that scales with the frequency, so all unique
    /// values are useful.
    var uiRounded: Frequency {
        if self < 200 {
            return self.rounded(to: 1)
        } else if self < 500 {
            return self.rounded(to: 5)
        } else if self < 1000 {
            return self.rounded(to: 10)
        } else {
            return self.rounded(to: 100)
        }
    }
    
    /// Returns, when self is a frequency in Hz, the octave distance to 20Hz
    var asOctave: Octave {
        return AudioMath.octave(fromFreq: self)
    }
    
    /**
    Returns the octave distance to another frequency

     - Parameter otherFreq: The frequency in Hz to calculate the distance to

     - Returns: An octave representing the distance to the provided frequency
     */
    func octaves(to otherFreq: Frequency) -> Octave {
        return log(self / otherFreq) / log(2.0)
    }
    
    func percentage(in range: FrequencyRange) -> Double {
        let octave = AudioMath.octave(fromFreq: self, baseOctaveFreq: range.lowerBound)
        let upperOctave = AudioMath.octave(fromFreq: range.upperBound, baseOctaveFreq: range.lowerBound)
        return octave / upperOctave
    }
    
    static func random(in range: FrequencyRange, disfavoring disfavored: Frequency?, repelEdges: Bool) -> Frequency {
        return AudioMath.randomFreq(in: range, disfavoring: disfavored, repelEdges: repelEdges)
    }
}
