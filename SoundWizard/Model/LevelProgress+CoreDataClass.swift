//
//  LevelProgress+CoreDataClass.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/3/20.
//
//

import Foundation
import CoreData

@objc(LevelProgress)
public class LevelProgress: NSManagedObject {
    
    var topScore: Int? {
        return scores.sorted().last
    }
    
    func updateStarsEarned(starScores: [Int]) {
        guard let topScore = self.topScore else {
            starsEarned = 0
            return
        }
        
        if topScore >= starScores[2] {
            starsEarned = 3
        } else if topScore >= starScores[1] {
            starsEarned = 2
        } else if topScore >= starScores[0] {
            starsEarned = 1
        } else {
            starsEarned = 0
        }
    }
}
