//
//  Level.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

// TODO: I want to use Level conformers as a type, so I can't use associated types (PATs). What I can do is break up
//       the Level requirements into structs that in abstract away the functionality I needed. I can also use the game
//       enum with custom values for each case.

import SwiftUI

protocol GameBuilder {}

protocol Level {
    
    var id: String { get }
    var game: Game { get }
    //var scores: [Int] { get }
    var number: Int { get }
    var audioMetadata: [AudioMetadata] { get }
    //var starScores: [Int] { get }
    var difficulty: LevelDifficulty { get }
    var scoreData: ScoreData { get set }
    
   // var instructionViewBuilder: InstructionViewBuilder { get }
        
}

extension Level {
    
    var audioSourceDescription: String {
        if audioMetadata.count == 1 {
            return audioMetadata[0].name
        }
        return "Multiple Samples"
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

//class TestLevel: Level {
//    
//    typealias GameType = EQDetectiveGame
//    
//    var id: String = "test"
//    
//    var game: Game = .eqDetective
//        
//    var number: Int = 3
//    
//    var audioMetadata: [AudioMetadata] = [TestMetaData()]
//    
//    var starScores: [Int] = [300, 500, 700]
//    
//    var scores: [Int] = [500]
//    
//    var difficulty: LevelDifficulty = .easy
//    
//    func makeGame() -> EQDetectiveGame {
//        EQDetectiveGame(level: self as!, gameViewState: <#T##Binding<GameViewState>#>)
//    }
//    
//    init() {}
//    
//}
