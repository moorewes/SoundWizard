//
//  EQMatchLevel.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import Foundation

struct EQMatchLevel: Level {
    var id: String
    var game: Game
    var number: Int
    var audioMetadata: [AudioMetadata]
    var difficulty: LevelDifficulty
    var scoreData: ScoreData
    
    var bandFocus: BandFocus
    let filterCount: Int
    let staticFrequencies: [Frequency]? = nil
    let staticGainValues: [Double]? = nil
    
    lazy var guessError = GuessError(level: self)
    var variesFrequency: Bool { staticFrequencies == nil }
    var variesGain: Bool { staticGainValues == nil }
}

extension EQMatchLevel {
    struct GuessError {
        var gain: Gain?
        var octaves: Double?
        
        init(gain: Gain?, octaves: Octave?) {
            self.gain = gain
            self.octaves = octaves
        }
        
        init(level: EQMatchLevel) {
            switch level.difficulty {
            case .easy, .custom:
                octaves = level.variesFrequency ? level.bandFocus.octaveSpan / 4 : nil
                gain = level.variesGain ? Gain(dB: 7) : nil
            case .moderate:
                octaves = level.variesFrequency ? level.bandFocus.octaveSpan / 6 : nil
                gain = level.variesGain ? Gain(dB: 6) : nil
            case .hard:
                octaves = level.variesFrequency ? level.bandFocus.octaveSpan / 8 : nil
                gain = level.variesGain ? Gain(dB: 5) : nil
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
