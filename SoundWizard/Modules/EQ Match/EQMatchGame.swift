//
//  EQMatchGame.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import SwiftUI

class EQMatchGame: ObservableObject, StandardGame {
    typealias ConductorType = EQMatchConductor
    typealias TurnType = Turn
    
    var level: EQMatchLevel
    var conductor: EQMatchConductor?
    var turns = [Turn]()
    var practicing: Bool

    var turnsPerStage = 5
    var timeBetweenTurns: Double = 1.2
    var scoreMultiplier = ScoreMultiplier()
    var lives = Lives()
    
    @Published var guessFilterData = [EQBellFilterData]() {
        didSet {
            if practicing {
                conductor?.update(data: guessFilterData)
            }
        }
    }
    
    var isPracticingBetweenTurns: Bool {
        practicing && turns.last?.isComplete ?? false
    }
    
    var actionButtonTitle: String {
        isPracticingBetweenTurns ? "Continue" : "Submit"
    }
    
    init(level: EQMatchLevel, practice: Bool, completionHandler: GameCompletionHandling) {
        self.level = level
        self.practicing = practice
        self.guessFilterData = level.initialFilterData
        self.conductor = EQMatchConductor(source: level.audioMetadata[0], filterData: guessFilterData)
        
        conductor?.startPlaying()
    }
    
    func startTurn() {
        turns.append(Turn(number: turns.count, solution: newSolution()))
    }
    
    func action() {
        
    }
    
    private func newSolution() -> [EQBellFilterData] {
        var solution = guessFilterData
        for i in 0..<solution.count {
            solution[i].shuffleGain()
            if level.changesFrequency {
                solution[i].shuffleFrequency()
            }
        }
        
        return solution
    }
    
}

extension EQMatchGame {
    struct Turn: GameTurn {
        var number: Int
        let solution: [EQBellFilterData]
        var score: TurnScore?
    }
}

private extension EQBellFilterData {
    mutating func shuffleGain() {
        let randomInt = Int.random(in: Int(dBGainRange.lowerBound)...Int(dBGainRange.upperBound))
        gain.dB = Float(randomInt)
    }
    
    mutating func shuffleFrequency() {
        let freq = Frequency.random(in: frequencyRange, disfavoring: frequency, repelEdges: true)
        frequency = freq
    }
}

struct EQMatchLevel: Level {
    var id: String
    var game: Game
    var number: Int
    var audioMetadata: [AudioMetadata]
    var difficulty: LevelDifficulty
    var scoreData: ScoreData
    
    var bandFocus: BandFocus
    let filterCount: Int
    let staticFrequencies: [Frequency]?
    var changesFrequency: Bool { staticFrequencies == nil }
}
