//
//  GameShellManager.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/24/20.
//

import SwiftUI

class GameShellManager: ObservableObject {
    
    var level: Level {
        didSet {
            objectWillChange.send()
        }
    }
    
    @Published var starsJustEarned = [Int]()
    @Published var newTopScore: Int?
    
    // TODO: Clean up, starsJustEarned can be calculated from progress scores
    @Published var gameViewState: GameViewState = .preGame {
        didSet {
            if gameViewState == .inGame {
                starsAtGameStart = level.starsEarned
                newTopScore = nil
            } else if gameViewState == .gameCompleted {
                starsJustEarned = Array(1...3).filter { $0 > starsAtGameStart && $0 <= level.starsEarned }
                print("starting game with \(starsJustEarned) stars")
                if let newScore = level.progress!.scores.last,
                   newScore > topScoreAtGameStart {
                    // TODO: Top Score counter only animates when using this block
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.newTopScore = newScore
                    }
                }
            }
        }
    }
    
    var topScore: Int {
        return level.topScore
    }
    
    var topScoreAtGameStart: Int
    private var starsAtGameStart = 0
    
            
    init(level: Level) {
        self.level = level
        topScoreAtGameStart = level.topScore
    }
    
    func quitGame() {
        gameViewState = .gameQuitted
    }
    
    func showInfoView() {
        
    }
    
    func showSettingsView() {
        
    }
    
}
