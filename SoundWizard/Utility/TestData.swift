//
//  TestData.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/17/20.
//

import Foundation

struct TestData {
        
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

// MARK: - Game Handling

extension TestData {
    
    struct GameHandler: GameHandling {
        var level: Level = TestData.eqdLevel
        var startHandler: GameStartHandling = GameStartHandler()
        var completionHandler: GameCompletionHandling = GameCompletionHandler()
        var state: GameViewState = .inGame(practicing: false)
    }
    
    struct GameStartHandler: GameStartHandling {
        func startGame(practicing: Bool) {
            
        }
    }
    
    struct GameCompletionHandler: GameCompletionHandling {
        func finishGame(score: GameScore) {
            TestData.eqdLevel.scoreData.addScore(score.value)
        }
        
        func quitGame() {
            
        }

    }
    
}




