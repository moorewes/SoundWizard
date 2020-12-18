//
//  TestData.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/17/20.
//

import Foundation

struct TestData {
    
    static var level = Level(eqdLevel)
    
    static var eqdLevel = EQDLevel(id: "test level",
                                   game: .eqDetective,
                                   number: 1,
                                   difficulty: .easy,
                                   audioMetadata: [TestAudioMetadata()],
                                   scoreData: ScoreData(starScores: [300, 600, 900],
                                                        scores: [400, 100]),
                                   bandFocus: .all,
                                   filterGain: 8,
                                   filterQ: 8,
                                   octaveErrorRange: 2)
        
    struct TestAudioMetadata: AudioMetadata {
        var name = "Pink Noise"
        var filename = "Pink.aif"
        var isStock = true
        var url: URL {
            AudioFileManager.shared.url(for: self)
        }
    }
    
}

struct TestLevel: LevelVariant {
    var id = "test level"
    
    var game: Game = .eqDetective
    
    var number: Int = 1
    
    var audioMetadata: [AudioMetadata] = [TestAudioMetadata()]
    
    var difficulty: LevelDifficulty = .easy
    
    var scoreData: ScoreData = ScoreData(starScores: [300, 600, 900], scores: [400, 100])
    
    struct TestAudioMetadata: AudioMetadata {
        var name = "Pink Noise"
        var filename = "Pink.aif"
        var isStock = true
        var url: URL {
            AudioFileManager.shared.url(for: self)
        }
    }
    
}


