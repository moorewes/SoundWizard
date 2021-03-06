//
//  ScoreFeedback.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/29/20.
//

import Foundation

enum ScoreFeedback {
    private static let perfectScoreStrings = ["amazing", "nailed it", "bullseye", "wow"]
    private static let greatScoreStrings = ["great", "very nice", "very close", "nearly perfect", "very nice"]
    private static let fairScoreStrings = ["good", "in the ballpark", "not bad"]
    private static let justMissedScoreStrings = ["not quite", "just missed", "so close", "almost"]
    private static let failedScoreStrngs = ["try again", "keep trying", "missed", "off the mark"]

    static func randomString(for successLevel: ScoreSuccess) -> String {
        let strings = allStrings(for: successLevel)
        let i = Int.random(in: 0..<strings.count)
        return strings[i]
    }
    
    private static func allStrings(for successLevel: ScoreSuccess) -> [String] {
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
