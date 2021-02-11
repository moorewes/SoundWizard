//
//  TestData.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/17/20.
//

import Foundation

struct TestData {
    static var eqdLevel = EQDLevel(
        id: "test level",
        game: .eqDetective,
        number: 1,
        difficulty: .easy,
        audioMetadata: [drumAudioMetadata],
        scoreData: ScoreData(starScores: [300, 600, 900],
                             scores: [400, 100]),
        bandFocus: .all,
        filterGain: Gain(dB: 8),
        filterQ: 8,
        octaveErrorRange: 2
    )
    
    static var eqMatchLevel = EQMatchLevel(
        id: "test level",
        number: 1,
        audioMetadata: [drumAudioMetadata],
        difficulty: .easy,
        format: EQMatchLevel.Format(mode: .free, bandCount: .dual, bandFocus: .all),
        scoreData: ScoreData(starScores: [300, 600, 900],
                             scores: [400, 100])
    )
    
    static var drumAudioMetadata = AudioMetadata(
        id: "stock.Pink Noise",
        name: "Pink Noise",
        filename: "Pink.aif",
        isStock: true,
        url: AudioFileManager.shared.url(filename: "Drums.wav", isStock: true)
    )
    
    static var cryAudioMetadata = AudioMetadata(
        id: "stock.Cry",
        name: "Cry",
        filename: "Cry.wav",
        isStock: true,
        url: AudioFileManager.shared.url(filename: "Cry.wav", isStock: true)
    )
    
    static var dawnAudioMetadata = AudioMetadata(
        id: "stock.Dawn",
        name: "Dawn",
        filename: "Dawn.wav",
        isStock: true,
        url: AudioFileManager.shared.url(filename: "Dawn.wav", isStock: true)
    )
    
    static var audioMetadataArray = [
        drumAudioMetadata,
        cryAudioMetadata,
        dawnAudioMetadata
    ]
}

// MARK: - Game Handling

extension TestData {
    static var stateController = TestStateController(levelStore: LevelStore())
    
    struct GameHandler: GameHandling {
        var level: Level & GameBuilding = TestData.eqdLevel
        var startHandler: GameStartHandling = GameStartHandler()
        var gameBuilder: GameBuilding { return level }
        var completionHandler: GameCompletionHandling = GameCompletionHandler()
        var state: GameViewState
    }
    
    struct GameStartHandler: GameStartHandling {
        func play() {
            
        }
        
        func practice() {
            
        }
    }
    
    struct GameCompletionHandler: GameCompletionHandling {
        func finish(score: GameScore) {
            TestData.eqdLevel.scoreData.addScore(score.value)
        }
        
        func quit() {
            
        }

    }
    
    class TestStateController: StateController {}
    
    struct LevelStore: LevelStoring, LevelFetching {
        
        func add(level: Level) {
            
        }
        
        func update(level: Level) {
            
        }
        
        func delete(level: Level) {
            
        }
        
        func fetchLevels(for game: Game) -> [Level] {
            return [TestData.eqdLevel]
        }
    }
}
