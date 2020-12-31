//
//  EQMatchLevel.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import Foundation

struct EQMatchLevel: Level {
    let game: Game = .eqMatch
    
    var id: String
    var number: Int
    var audioMetadata: [AudioMetadata]
    var difficulty: LevelDifficulty
    let format: Format
    
    // TODO: Implement
    var scoreData: ScoreData = ScoreData(starScores: [300, 500, 700], scores: [])
    
    var staticFrequencies: [Frequency]? {
        guard format.mode == .fixedFrequency else { return nil }
        
        let bandCount = format.bandCount.rawValue
        return Array(0..<bandCount).map { index in
            let percentage = Double(index) / Double(bandCount) + 0.5 / Double(bandCount)
            return AudioMath.frequency(percent: percentage, in: format.bandFocus.range)
        }
    }
    
    var staticGainValues: [Double]? {
        guard format.mode == .fixedGain else { return nil }
        
        // TODO: Implement
        return Array(repeating: 6.0, count: format.bandCount.rawValue)
    }
    
    lazy var guessError = GuessError(level: self)
    var variesFrequency: Bool { staticFrequencies == nil }
    var variesGain: Bool { staticGainValues == nil }
}

extension EQMatchLevel {
    struct Format: Equatable {
        let mode: Mode
        let bandCount: BandCount
        let bandFocus: BandFocus
    }
    
    enum Mode: Int, CaseIterable, UIDescribing {
        case free = 1, fixedGain, fixedFrequency
        
        var uiDescription: String {
            switch self {
            case .fixedGain: return "Fixed Gain"
            case .fixedFrequency: return "Fixed Freq"
            case .free: return "Free"
            }
        }
    }
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
                octaves = level.variesFrequency ? level.format.bandFocus.octaveSpan / 2 : nil
                gain = level.variesGain ? Gain(dB: 6) : nil
            case .moderate:
                octaves = level.variesFrequency ? level.format.bandFocus.octaveSpan / 3 : nil
                gain = level.variesGain ? Gain(dB: 5) : nil
            case .hard:
                octaves = level.variesFrequency ? level.format.bandFocus.octaveSpan / 4 : nil
                gain = level.variesGain ? Gain(dB: 4) : nil
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
