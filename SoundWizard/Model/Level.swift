//
//  Level.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import Foundation

protocol Level {
    
    var id: String { get }
    var game: Game { get }
    var progress: LevelProgress? { get }
    var number: Int { get }
    var audioMetadata: [AudioMetadata] { get }
    var starScores: [Int] { get }
    var difficulty: LevelDifficulty { get }
        
}

extension Level {
    
    var audioSourceDescription: String {
        if audioMetadata.count == 1 {
            return audioMetadata[0].name
        }
        return "Multiple Samples"
    }
    
    var starsEarned: Int {
        progress?.starsEarned ?? 0
    }
    
    var topScore: Int {
        progress?.scores.sorted().last ?? 0
    }
    
}

struct TestMetaData: AudioMetadata {
    var name = "Pink Noise"
    var filename = "Pink.aif"
    var isStock = true
    var url: URL {
        AudioFileManager.shared.url(for: self)
    }
}

class TestLevel: Level {
    
    var id: String = "test"
    
    var game: Game = .eqDetective
    
    var progress: LevelProgress?
    
    var number: Int = 3
    
    var audioMetadata: [AudioMetadata] = [TestMetaData()]
    
    var starScores: [Int] = [300, 500, 700]
    
    var difficulty: LevelDifficulty = .easy
    
    init() {}
    
}

