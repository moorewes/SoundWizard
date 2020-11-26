//
//  ScoreFeedback.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/29/20.
//

import Foundation

enum ScoreSuccessLevel: Int, CaseIterable {
    
    case perfect = 0, great, fair, justMissed, failed
    
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
}

enum ScoreFeedback {
    
    // MARK: - Properties
    
    private static let perfectScoreStrings = ["amazing", "nailed it", "bullseye", "wow"]
    private static let greatScoreStrings = ["great", "very nice", "very close", "nearly perfect", "very nice"]
    private static let fairScoreStrings = ["good", "in the ballpark", "not bad"]
    private static let justMissedScoreStrings = ["not quite", "just missed", "so close", "almost"]
    private static let failedScoreStrngs = ["try again", "keep trying", "missed", "off the mark"]
    
    // MARK: Private
    
    // MARK: - Methods
    
    // MARK: Internal
    
    static func randomString(for successLevel: ScoreSuccessLevel) -> String {
        let strings = allStrings(for: successLevel)
        let i = Int.random(in: 0..<strings.count)
        return strings[i]
    }
    
    // MARK: Private
    
    private static func allStrings(for successLevel: ScoreSuccessLevel) -> [String] {
        switch successLevel {
        case .perfect:
            return perfectScoreStrings
        case .great:
            return greatScoreStrings
        case .fair:
            return fairScoreStrings
        case .justMissed:
            return justMissedScoreStrings
        case .failed:
            return failedScoreStrngs
        }
    }

}
