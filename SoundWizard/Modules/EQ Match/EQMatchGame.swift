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
    
    var practicing: Bool
    var completionHandler: GameCompletionHandling

    var turnsPerStage = 5
    var timeBetweenTurns: Double = 1.2
    private let baseOctaveErrorMultiplier: Double = 0.7
    private let minOctaveDistanceBetweenSolutionFrequencies = 0.5
    
    var scoreMultiplier = ScoreMultiplier()
    var lives = Lives()
    
    @Published var turns = [Turn]() {
        didSet {
            guard let turn = turns.last else { return }
            if let score = turn.score {
                lives.update(for: score.successLevel)
                scoreMultiplier.update(for: score.successLevel)
            } else {
                filterMode = .solution
            }
        }
    }
    @Published var solutionFilterData = [EQBellFilterData]()
    
    @Published var guessFilterData = [EQBellFilterData]() {
        didSet {
            conductor?.update(guess: guessFilterData.auData)
        }
    }
    
    @Published var filterMode: FilterMode = .solution {
        didSet {
            conductor?.set(filterMode: filterMode)
        }
    }
    
    var displayedFilterData: [EQBellFilterData] {
        guard showingResults else { return guessFilterData }
        
        switch filterMode {
        case .guess:
            return guessFilterData
        case .solution:
            return solutionFilterData
        }
    }
    
    var frequencyRange: FrequencyRange {
        level.format.bandFocus.range
    }
    
    // TODO: Determine whether this is constant for all levels
    var gainRange: ClosedRange<Double> {
        return -9...9
    }
    
    var turnResult: Turn.Result? {
        turns.last?.result
    }
    
    var solutionLineColor: Color {
        guard let successLevel = turnResult?.score.successLevel else {
            return .clear
        }
        return Color.successLevelColor(successLevel)
    }
    
    var showingResults: Bool {
        turns.last?.isComplete ?? false
    }
    
    var actionButtonTitle: String {
        !showingResults ? "SUBMIT" : lives.isDead ? "FINISH" : "NEXT"
    }
    
    // MARK: Private
    
    private var maxGuessError: EQMatchLevel.GuessError {
        level.guessError.applyingMultiplier(guessErrorMultiplier)
    }
    
    // TODO: Can probably be refactored to default protocol implementation
    private var guessErrorMultiplier: Octave {
        return pow(baseOctaveErrorMultiplier, Double(stage))
    }
    
    init(level: EQMatchLevel, practice: Bool, completionHandler: GameCompletionHandling) {
        self.level = level
        self.practicing = practice
        self.guessFilterData = level.initialFilterData
        self.completionHandler = completionHandler
        self.conductor = EQMatchConductor(source: level.audioMetadata[0],
                                          filterData: guessFilterData.auData)
        
        startTurn()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.conductor?.startPlaying()
        }
    }
    
    // MARK: - Methods
    
    // MARK: User Actions
    
    func startTurn() {
        let solution = newSolution()
        setupGuessData(for: solution)
        conductor?.update(solution: solution.auData)
        turns.append(Turn(number: turns.count, solution: solution, guessError: maxGuessError))
        solutionFilterData = solution
        filterMode = .solution
    }
    
    func endTurn() {
        turns[turns.count - 1].endTurn(guess: guessFilterData)
        fireFeedback()
    }
    
    func action() {
        if lives.isDead {
            finish()
        } else if showingResults {
            startTurn()
        } else {
            endTurn()
        }
    }
    
    func finish() {
        let gameScore = GameScore(turnScores: turnScores)
        completionHandler.finish(score: gameScore)
    }
    
    func stopAudio() {
        conductor?.stopPlaying()
    }
    
    // MARK: Private Methods
    
    private func setupGuessData(for solution: [EQBellFilterData]) {
        for i in 0..<guessFilterData.count {
            switch level.format.mode {
            case .free:
                guessFilterData[i].gain = Gain.unity
                guessFilterData[i].frequency = level.startFrequency(filterNumber: i)
            case .fixedFrequency:
                guessFilterData[i].gain = Gain.unity
            case .fixedGain:
                let gain = solution[i].gain
                guessFilterData[i].gain = gain
                guessFilterData[i].dBGainRange = gain.dB...gain.dB
                guessFilterData[i].frequency = level.startFrequency(filterNumber: i)
            }
        }
    }
    
    // TODO: Prevent adjacent bands from generating random frequencies that are close
    private func newSolution() -> [EQBellFilterData] {
        var solution = guessFilterData
        for i in 0..<solution.count {
            solution[i].dBGainRange = gainRange
            solution[i].shuffleGainToNonZeroInt()
            solution[i].dBGainRange = -9...9 // TODO: Magic numbers
            if level.variesFrequency {
                if i > 0 {
                    solution[i].shuffleFrequency(minOctaveDistance: minOctaveDistanceBetweenSolutionFrequencies,
                                                 to: solution[i-1].frequency)
                } else {
                    solution[i].shuffleFrequency()
                }
            }
        }
        
        return solution
    }
    
}

private extension EQBellFilterData {
    mutating func shuffleGainToNonZeroInt() {
        // Quit if range is 0...0
        guard !(dBGainRange.lowerBound == 0 && dBGainRange.upperBound == 0) else {
            return
        }
        
        let dBValue = Int.random(in: Int(dBGainRange.lowerBound)...Int(dBGainRange.upperBound))
        
        // 0 dB would make it impossible to guess frequency
        guard dBValue != 0 else {
            shuffleGainToNonZeroInt()
            return
        }
        gain.dB = Double(dBValue)
    }
    
    mutating func shuffleFrequency(minOctaveDistance: Double? = nil, to otherFreq: Frequency? = nil) {
        frequency = Frequency.random(in: frequencyRange, disfavoring: frequency, repelEdges: true)
        
        // If adjacent bands have very close frequencies, the game quality suffers, so reshuffle
        if let minDistance = minOctaveDistance,
           let otherFreq = otherFreq,
           abs(otherFreq.octaves(to: frequency)) < minDistance {
            print(otherFreq.octaves(to: frequency))
            shuffleFrequency(minOctaveDistance: minDistance * 0.95, to: otherFreq)
        }
    }
    
}

