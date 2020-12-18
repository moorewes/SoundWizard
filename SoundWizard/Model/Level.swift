//
//  Level.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import SwiftUI

@dynamicMemberLookup
enum Level: Identifiable {
    case eqDetective(EQDLevel)
    
    var id: String {
        self.game.name + "\(self.number)"
    }
}

extension Level {
    subscript<T>(dynamicMember keyPath: KeyPath<LevelVariant, T>) -> T {
        switch self {
        case .eqDetective(let level):
            return level[keyPath: keyPath]
        }
    }
}

protocol LevelStorageObject {
    var level: Level { get }
}

extension Level {
    init(_ eqdLevel: EQDLevel) {
        self = .eqDetective(eqdLevel)
    }

    var levelVariant: LevelVariant {
        switch self {
        case .eqDetective(let level):
            return level
        }
    }
}

extension Array where Element == Level {
    func levelVariants() -> [LevelVariant] {
        self.map { $0.levelVariant }
    }
}

protocol LevelVariant {
    var id: String { get }
    var game: Game { get }
    var number: Int { get }
    var audioMetadata: [AudioMetadata] { get }
    var difficulty: LevelDifficulty { get }
    var scoreData: ScoreData { get set }
}

extension LevelVariant {
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

//protocol Level {
//
//    var id: String { get }
//    var game: Game { get }
//    var number: Int { get }
//    var audioMetadata: [AudioMetadata] { get }
//    var stars: StarProgress { get }
//    var difficulty: LevelDifficulty { get }
//    var scoreData: ScoreData { get set }
//
//}

//protocol LevelRepresentable {
//    var levelItem: Level { get }
//}

//struct Level: Identifiable {
//
//    var id: String
//    var game: Game
//    var difficulty: LevelDifficulty
//    var stars: StarProgress
//    var audioMetadata: [AudioMetadata]
//
//}
