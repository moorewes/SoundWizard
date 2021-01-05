//
//  EQMatchLevel+GuessError.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/4/21.
//

import Foundation

extension EQMatchLevel {
    struct GuessError {
        var gain: Gain?
        var octaves: Double?
        
        init(gain: Gain?, octaves: Octave?) {
            self.gain = gain
            self.octaves = octaves
        }
        
        init(level: EQMatchLevel) {
            let octavesPerBand = level.format.bandFocus.octaveSpan /
                Double(level.format.bandCount.rawValue)
            let includeGain = level.format.mode != .fixedGain
            switch level.difficulty {
            case .easy, .custom:
                octaves = level.variesFrequency ? octavesPerBand / 4 : nil
                gain = includeGain ? Gain(dB: 6) : nil
            case .moderate:
                octaves = level.variesFrequency ? octavesPerBand / 5 : nil
                gain = includeGain ? Gain(dB: 5) : nil
            case .hard:
                octaves = level.variesFrequency ? octavesPerBand / 6 : nil
                gain = includeGain ? Gain(dB: 4) : nil
            }
        }
        
        func applyingMultiplier(_ multiplier: Double) -> Self {
            var result = self
            if result.gain != nil {
                result.gain!.dB *= multiplier
            }
            if result.octaves != nil {
                result.octaves! *= multiplier
            }
            return result
        }
    }
}
