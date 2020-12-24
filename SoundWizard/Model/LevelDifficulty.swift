//
//  LevelDifficulty.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/30/20.
//

import Foundation

enum LevelDifficulty: Int, CaseIterable, Identifiable, UIDescribing {
    case easy = 1, moderate, hard, custom
    
    var id: Int { self.rawValue }
    
    var uiDescription: String {
        switch self {
        case .easy: return "Easy"
        case .moderate: return "Moderate"
        case .hard: return "Hard"
        case .custom: return "Custom"
        }
    }
}
