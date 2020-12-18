//
//  ScoreData.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/14/20.
//

import Foundation

struct ScoreData {
    
    let starScores: [Int]
    var scores: [Int]
    
    var topScore = 0
    var starsEarned = 0
    var newStars = [Int]()
        
    init(starScores: [Int], scores: [Int]) {
        self.starScores = starScores
        self.scores = scores
        topScore = scores.sorted().last ?? 0
        starsEarned = starsEarned(for: topScore)
    }
    
    mutating func addScore(_ score: Int) {
        scores.append(score)
        
        guard score > topScore else {
            newStars = []
            return
        }
        
        topScore = score
        
        // TODO: Make less vague
        let stars = starsEarned(for: score)
        guard stars > starsEarned else {
            newStars = []
            return
        }
        
        newStars = [1, 2, 3].filter { $0 > starsEarned && $0 <= stars }
        starsEarned = stars
    }
    
    private func starsEarned(for score: Int) -> Int {
        for i in [2, 1, 0] {
            if score >= starScores[i] { return i + 1 }
        }
        
        return 0
    }
}
