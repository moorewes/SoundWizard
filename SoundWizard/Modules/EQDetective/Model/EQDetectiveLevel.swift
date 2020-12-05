//
//  EQDetectiveLevel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import Foundation

class EQDetectiveLevel: Level, Identifiable {
    
    // MARK: - Properties
        
    let game: Game = .eqDetective
    let numberOfTurns = 10
    let levelNumber: Int
    let audioSource: AudioSource
    let starScores: [Int]
    let bandFocus: BandFocus
    let description: String
    
    var id: Int { return levelNumber }
    
    var octavesVisible: Octave {
        bandFocus.range.upperBound.asOctave - bandFocus.range.lowerBound.asOctave
    }
    
    var filterIsBoost: Bool { return filterGainDB > 0 }
    
    lazy var instructions: String = instructionString()
    
    lazy var progress: LevelProgress = {
        let progress = progressManager.progress(for: self)
        progress.updateStarsEarned(starScores: starScores)
        return progress
    }()
    
    // MARK: Internal
    
    let filterGainDB: Float
    let filterQ: Float
    let difficulty: LevelDifficulty
    
    lazy var octaveErrorRange: Octave = {
        switch difficulty {
        case .easy:
            return bandFocus.octaveSpan / 4
        case .moderate:
            return bandFocus.octaveSpan / 6
        case .hard:
            return bandFocus.octaveSpan / 8
        }
    }()
    
    var progressManager = UserProgressManager.shared
    
    // MARK: - Initializers
    
    init(levelNumber: Int,
         audioSource: AudioSource,
         starScores: [Int],
         filterGainDB: Float,
         filterQ: Float,
         difficulty: LevelDifficulty,
         bandFocus: BandFocus) {
        self.levelNumber = levelNumber
        self.audioSource = audioSource
        self.starScores = starScores
        self.filterGainDB = filterGainDB
        self.filterQ = filterQ
        self.difficulty = difficulty
        self.bandFocus = bandFocus
        
        description = bandFocus.uiDescription
    }
 
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func updateProgress(score: Int) {
        progress.scores.append(score)
        progress.updateStarsEarned(starScores: starScores)
        save()
    }
    
    func save() {
        progressManager.save()
    }
    
    // MARK: Private
    
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
