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
    var scores: [Int] { get }
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
    
    var topScore: Int {
        return scores.sorted().last ?? 0
    }
        
    var starsEarned: Int {
        return starsEarned(for: topScore)
    }
            
    var newStarsEarnedOnLastRound: [Int] {
        var scores = self.scores
        guard let _ = scores.popLast() else { return [0] }
        let prevTopScore = scores.sorted().last ?? 0
        
        let starsEarnedBeforeLastRound = starsEarned(for: prevTopScore)
        
        return Array(1...3).filter { $0 > starsEarnedBeforeLastRound && $0 <= starsEarned }
    }
    
    func starsEarned(for score: Int) -> Int {
        for i in [2, 1, 0] {
            if score >= starScores[i] { return i + 1 }
        }
        
        return 0
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
        
    var number: Int = 3
    
    var audioMetadata: [AudioMetadata] = [TestMetaData()]
    
    var starScores: [Int] = [300, 500, 700]
    
    var scores: [Int] = [500]
    
    var difficulty: LevelDifficulty = .easy
    
    init() {}
    
}

