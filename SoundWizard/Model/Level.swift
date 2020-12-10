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
    var progress: LevelProgress { get set }
    var levelNumber: Int { get }
    var audioSource: AudioSource { get }
    var starScores: [Int] { get }
    var difficulty: LevelDifficulty { get }
    var description: String { get }
    
    func updateProgress(score: Int)
    
}

