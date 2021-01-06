//
//  EQMatchLevel+Formats.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/5/21.
//

import Foundation

extension EQMatchLevel {
    struct Format: Equatable {
        var mode: Mode
        var bandCount: BandCount
        var bandFocus: BandFocus
    }
    
    enum Mode: Int, CaseIterable, UIDescribing {
        case fixedGain = 1, fixedFrequency, free
        
        var uiDescription: String {
            switch self {
            case .fixedGain: return "Freq"
            case .fixedFrequency: return "Gain"
            case .free: return "Both"
            }
        }
    }
    
    static func supportedModes(difficulty: LevelDifficulty, bandCount: BandCount) -> [EQMatchLevel.Mode] {
        switch difficulty {
        case .easy:
            return [.fixedFrequency, .fixedGain]
        default:
            return EQMatchLevel.Mode.allCases
        }
    }
}
