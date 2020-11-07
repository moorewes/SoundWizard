//
//  LevelMock.swift
//  SoundWizardTests
//
//  Created by Wes Moore on 11/6/20.
//

@testable import SoundWizard

class LevelMock: Level {
    
    var game: Game = .eqDetective
    
    var progress: LevelProgress = {
        let progress = LevelProgress()
        return progress
    }()
    
    var numberOfTurns: Int = 10
    
    var levelNumber: Int = 1
    
    var audioSource: AudioSource = .acousticDrums
    
    var starScores: [Int] = [300, 600, 900]
    
    var instructions: String = "Mock instructions"
    
    func updateProgress(round: Round) {
        progress.scores.append(Int(round.score))
    }

}
