//
//  ScoreSuccessLevel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/30/20.
//

import Foundation

enum ScoreSuccessLevel: Int, CaseIterable, Comparable {
    
    case failed = 0, justMissed, fair, great, perfect
    
    init(score: Float) {
        if score >= 0.9 {
            self = .perfect
        } else if score >= 0.8 {
            self = .great
        } else if score >= 0.0 {
            self = .fair
        } else if score > -0.3 {
            self = .justMissed
        } else {
            self = .failed
        }
    }
    
    static func < (lhs: ScoreSuccessLevel, rhs: ScoreSuccessLevel) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
    
}
