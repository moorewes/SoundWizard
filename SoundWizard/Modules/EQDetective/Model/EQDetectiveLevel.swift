//
//  EQDetectiveLevel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import Foundation

class EQDetectiveLevel: Level {
    
    // MARK: - Properties
    
    // MARK: Level Conformance
    
    let game: Game = .eqDetective
    let numberOfTurns = 10
    let levelNumber: Int
    let audioSource: AudioSource
    let starScores: [Int]
    
    lazy var instructions: String = instructionString()
    
    lazy var progress: LevelProgress = progressManager.progress(for: self)
    
    // MARK: Internal
    
    let filterGainDB: Float
    let filterQ: Float
    let octaveErrorRange: Float
    
    var progressManager = UserProgressManager.shared
    
    // MARK: - Initializers
    
    init(levelNumber: Int,
         audioSource: AudioSource,
         starScores: [Int],
         filterGainDB: Float,
         filterQ: Float,
         octaveErrorRange: Float) {
        self.levelNumber = levelNumber
        self.audioSource = audioSource
        self.starScores = starScores
        self.filterGainDB = filterGainDB
        self.filterQ = filterQ
        self.octaveErrorRange = octaveErrorRange
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func updateProgress(round: Round) {
        progress.scores.append(Int(round.score))
        progress.starsEarned = starsEarned()
        save()
    }
    
    func save() {
        progressManager.save()
    }
    
    // MARK: Private
    
    private func starsEarned() -> Int {
        guard let topScore = progress.scores.sorted().last else { return 0 }
        if topScore >= starScores[2] {
            return 3
        } else if topScore >= starScores[1] {
            return 2
        } else if topScore >= starScores[0] {
            return 1
        } else {
            return 0
        }
    }
    
    private func instructionString() -> String {
        let filterType = filterGainDB > 0 ? "boost" : "cut"
        let octaveString = octaveErrorRange == 1 ? "octave" : "octaves"
        
        return """
            The audio sample has a bell filter set to a \(filterGainDB.uiString)dB \(filterType)

            Find the center frequency

            To pass, your guess must be within \(octaveErrorRange.uiString) \(octaveString)

            """
    }
    
    // MARK: - Internal Class Methods
    
    class func level(_ levelNumber: Int) -> EQDetectiveLevel? {
        guard levels.count > levelNumber else { return nil }
        
        return levels[levelNumber]
    }
    
}
