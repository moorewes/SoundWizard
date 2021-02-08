//
//  ScoreSuccessLevel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/30/20.
//

import Foundation

struct GameScore {
    var value: Int
    var turns: [Score]
    
    init(turnScores: [Score]) {
        self.turns = turnScores
        self.value = turnScores.reduce(0) { $0 + Int($1.value) }
    }
}

enum ScoreSuccess: Int, CaseIterable, Comparable {
    case failed = 0, justMissed, fair, great, perfect
    
    init(score: Double) {
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
    
    var succeeded: Bool {
        return self >= .fair
    }
    
    static func < (lhs: ScoreSuccess, rhs: ScoreSuccess) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

extension Collection where Element == Score {
    var meanValue: Double {
        map { $0.value }.mean
    }
    
    var meanSuccess: ScoreSuccess {
        let mean = map { Double($0.successLevel.rawValue) }.mean
        return ScoreSuccess(rawValue: Int(mean)) ?? .perfect
    }
}
