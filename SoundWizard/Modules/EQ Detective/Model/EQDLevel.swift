//
//  EQDetectiveLevel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import Foundation

class EQDLevel: Identifiable {
    
    // MARK: - Properties
        
    let game: Game = .eqDetective
    let numberOfTurns = 10
    let number: Int
    let starScores: [Int]
    let bandFocus: BandFocus
    let description: String
    
    var id: String { return "\(game.id).\(number)" }
    
    var audioSource: AudioSource
    
    var octavesVisible: Octave {
        bandFocus.range.upperBound.asOctave - bandFocus.range.lowerBound.asOctave
    }
    
    var filterIsBoost: Bool { return filterGainDB > 0 }
    
    lazy var instructions: String = instructionString()
    
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
    
    var progressManager = CoreDataManager.shared
    
    // MARK: - Initializers
    
    init(levelNumber: Int,
         audioSourceID: String,
         starScores: [Int],
         filterGainDB: Float,
         filterQ: Float,
         difficulty: LevelDifficulty,
         bandFocus: BandFocus) {
        self.number = levelNumber
        self.starScores = starScores
        self.filterGainDB = filterGainDB
        self.filterQ = filterQ
        self.difficulty = difficulty
        self.bandFocus = bandFocus
        
        let context = CoreDataManager.shared.container.viewContext
        //let level = EQDetectiveLevel(context: context)
        //level.bandFocus
        
        
        audioSource = AudioSource.source(id: audioSourceID, context: context)!
        
        description = bandFocus.uiDescription
    }
 
    
    // MARK: - Methods
    
    // MARK: Internal
    
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
    
    class func level(_ levelNumber: Int) -> EQDLevel? {
        guard levels.count > levelNumber else { return nil }
        
        return levels[levelNumber]
    }
    
}
