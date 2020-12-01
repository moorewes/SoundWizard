//
//  Octave.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import Foundation

typealias Octave = Float
typealias OctaveRange = ClosedRange<Octave>

extension Octave {
        
    var asFrequency: Frequency {
        AudioMath.freq(fromOctave: self, rounded: false)
    }
    
    var uiRoundedFreq: Frequency {
        return self.asFrequency.uiRounded
    }
    
}

struct Octave_ {
    
    private(set) var value: Float
    private(set) var frequency: Frequency
    private(set) var baseFrequency: Frequency
    
    init(frequency: Frequency, baseFrequency: Frequency) {
        self.frequency = frequency
        self.baseFrequency = baseFrequency
        self.value = AudioMath.octave(fromFreq: frequency, baseOctaveFreq: baseFrequency)
    }
    
}
