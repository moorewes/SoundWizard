//
//  Level.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import SwiftUI

protocol Level {
    var id: String { get }
    var game: Game { get }
    var number: Int { get }
    var audioMetadata: [AudioMetadata] { get }
    var difficulty: LevelDifficulty { get }
    var scoreData: ScoreData { get set }
}

extension Level {
    var stars: StarProgress {
        StarProgress(total: StarProgress.levelMax, earned: scoreData.starsEarned)
    }
    
    var audioSourceDescription: String {
        if audioMetadata.count == 1 {
            return audioMetadata[0].name
        }
        return "Multiple Samples"
    }
}

extension Array where Element == Level {
    func index(matching level: Level) -> Int? {
        self.firstIndex { $0.id == level.id }
    }
}
