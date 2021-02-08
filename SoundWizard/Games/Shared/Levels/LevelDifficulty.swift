//
//  LevelDifficulty.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/30/20.
//

import Foundation

enum LevelDifficulty: Int, CaseIterable, Identifiable {
    case easy = 1, moderate, hard, custom
    
    var id: Int { self.rawValue }
}

extension LevelDifficulty: UIDescribing {
    var uiDescription: String {
        switch self {
        case .easy: return "Beginner"
        case .moderate: return "Intermediate"
        case .hard: return "Expert"
        case .custom: return "Custom"
        }
    }
}

extension LevelDifficulty: Comparable {
    static func < (lhs: LevelDifficulty, rhs: LevelDifficulty) -> Bool {
        lhs.rawValue < rhs.rawValue
    }
}
