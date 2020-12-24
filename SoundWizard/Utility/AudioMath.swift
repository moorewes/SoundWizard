//
//  AudioMath.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/26/20.
//

import Foundation

struct AudioMath {
    // MARK: - Static Properties
    
    static let baseFrequency: Frequency = 20.0
    
    // MARK: - Static Methods
    
    /**
    Converts a frequency in Hz into an octave, using some base octave

     - Parameter freq: The frequency in Hz to convert
     - Parameter baseOctaveFreq: The base frequency in Hz from which the octave
                                 difference will be calculated. The default value
                                 is 20 Hz, representing octave 0
     - Parameter decimalPlaces: The rounding to be applied to the returned octave

     - Returns: An octave representing the difference between the provided
                frequency and the base frequency
     */
    static func octave(fromFreq freq: Frequency,
                       baseOctaveFreq: Frequency = baseFrequency,
                       roundingPlaces: Int? = nil) -> Octave {
        var octave = logf(freq / baseOctaveFreq) / logf(2.0)
        
        if let places = roundingPlaces {
            octave.round(places: places)
        }
        
        return octave
    }
    
    /**
     Converts an octave into a frequency
     
     - Parameter octave: The octave to be converted
     - Parameter baseOctaveFreq: The baseOctave to use as a comparison
     - Parameter rounded: A bool representing whether to round the resulting frequency
                          to a UI useful value
     
     - Returns: A frequency in Hz with the octave difference between the provided
                frequency and the base frequency
     */
    static func freq(fromOctave octave: Octave,
                     baseOctaveFreq: Frequency = baseFrequency,
                     rounded: Bool = true) -> Frequency {
        var freq = baseOctaveFreq * powf(2, octave)
        if rounded {
            freq = freq.uiRounded
        }
        
        return freq
    }
    
    static func frequency(percent: Float,
                          in range: FrequencyRange,
                          uiRounded: Bool = false) -> Frequency {
        let octaves = AudioMath.octaves(in: range)
        let octave = percent * octaves
        return AudioMath.freq(fromOctave: octave,
                                   baseOctaveFreq: range.lowerBound,
                                   rounded: true)
    }
    
    static func dBToPercent(dB: Float) -> Float {
        return powf(10, dB/10)
    }
    
    static func randomFreq(in range: FrequencyRange,
                           disfavoring disfavoredFreq: Float? = nil,
                           repelEdges: Bool) -> Float {
        let octaveRange = AudioMath.octaveRange(from: range, decimalPlaces: 1)
        var octave = randomOctave(in: octaveRange)
        
        // Weaken chances of frequencies close to edges
        if repelEdges && ( octave < 3.0 || octave > 9.0 ) {
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
        
        return AudioMath.freq(fromOctave: octave)
    }
    
    static func randomOctave(in range: ClosedRange<Float>) -> Float {
        let multiplier: Float = 1000.0
        let minBound = Int(range.lowerBound * multiplier)
        let maxBound = Int(range.upperBound * multiplier)
        let intRange = minBound...maxBound
        let random = Int.random(in: intRange)
        
        return Float(random) / multiplier
    }
    
    static func octaveRange(from freqRange: FrequencyRange,
                                    decimalPlaces: Int) -> ClosedRange<Float> {
        let lowerBound = AudioMath.octave(fromFreq: freqRange.lowerBound).rounded(places: decimalPlaces)
        let upperBound = AudioMath.octave(fromFreq: freqRange.upperBound).rounded(places: decimalPlaces)
        return lowerBound...upperBound
    }
    
    static func octaves(in range: FrequencyRange) -> Octave {
        return octave(fromFreq: range.upperBound, baseOctaveFreq: range.lowerBound)
    }
}

extension Float {
    mutating func round(places: Int) {
        let divisor = pow(10.0, Float(places))
        self = (self * divisor).rounded() / divisor
    }
    
    func rounded(places: Int) -> Float {
        let divisor = pow(10.0, Float(places))
        return (self * divisor).rounded() / divisor
    }
}

extension FloatingPoint {
    /**
     Returns this value rounded to the nearest multiple of the provided value.
     Useful when you want to round to certain numbers instead of digits or decimal places.
     Ex: 117.0.rounded(to: 5) returns 115
     
     - Parameter value: The nearest value to round to
     
     - Returns: A new value, representing self rounded to the nearest provided value
     */
    func rounded(to value: Self) -> Self {
       (self / value).rounded() * value
    }
}




