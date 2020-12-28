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
    private let baseOctaveErrorMultiplier: Float = 0.7
    
    var scoreMultiplier = ScoreMultiplier()
    var lives = Lives()
    
    @Published var guessFilterData = [EQBellFilterData]() {
        didSet {
            if practicing {
                conductor?.update(data: guessFilterData)
            }
        }
    }
    
    var turnResult: Turn.Result? {
        turns.last?.result
    }
    
    var isPracticingBetweenTurns: Bool {
        practicing && turns.last?.isComplete ?? false
    }
    
    var actionButtonTitle: String {
        isPracticingBetweenTurns ? "CONTINUE" : "SUBMIT"
    }
    
    // MARK: Private
    
    private var maxOctaveError: Octave {
        return level.maxOctaveError * maxOctaveErrorMultiplier
    }
        
    private var maxOctaveErrorMultiplier: Octave {
        return powf(baseOctaveErrorMultiplier, Float(stage))
    }
    
    
    init(level: EQMatchLevel, practice: Bool, completionHandler: GameCompletionHandling) {
        self.level = level
        self.practicing = practice
        self.guessFilterData = level.initialFilterData
        self.conductor = EQMatchConductor(source: level.audioMetadata[0], filterData: guessFilterData)
        
        conductor?.startPlaying()
    }
    
    // MARK: - Methods
    
    // MARK: User Actions
    
    func startTurn() {
        turns.append(Turn(number: turns.count, maxOctaveError: maxOctaveError, solution: newSolution()))
    }
    
    func action() {
        
    }
    
    // MARK: Private Methods
    
    // TODO: Prevent adjacent bands from generating random frequencies that are close
    private func newSolution() -> [EQBellFilterData] {
        var solution = guessFilterData
        for i in 0..<solution.count {
            solution[i].shuffleGain()
            if level.variesFrequency {
                solution[i].shuffleFrequency()
            }
        }
        
        return solution
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
