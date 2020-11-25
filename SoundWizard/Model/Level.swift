//
//  Level.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import Foundation

protocol Level {
    
    var game: Game { get }
    var progress: LevelProgress { get set }
    var numberOfTurns: Int { get }
    var levelNumber: Int { get }
    var audioSource: AudioSource { get }
    var starScores: [Int] { get }
    var instructions: String { get }
    
    func updateProgress(score: Int)
    
}

