//
//  Octave.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/25/20.
//

import Foundation

typealias Octave = Float

extension Octave {
    
    var asFrequency: Frequency {
        AudioMath.freq(fromOctave: self, rounded: false)
    }
    
    var uiRoundedFreq: Frequency {
        return self.asFrequency.uiRounded
    }
    
}
