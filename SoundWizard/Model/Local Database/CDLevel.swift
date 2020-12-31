//
//  CDLevel.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/30/20.
//

import CoreData

protocol CDLevel: class, Identifiable, LevelInfoProviding, ScoreUpdating {
    var managedObjectContext: NSManagedObjectContext? { get }
    var game: Game { get }
    var id_: String? { get set }
    var number_: Int64 { get set }
    var difficulty_: Int16 { get set }
    var scores_: [Int]? { get set }
    var starScores_: [Int]? { get set }
    var audioSources_: NSSet? { get }
}

protocol LevelInfoProviding {
    var id: String { get set }
    var scores: [Int] { get set }
    var audioMetadata: [AudioMetadata] { get }
    var difficulty: LevelDifficulty { get set }
    var number: Int { get set }
    var starScores: [Int] { get set }
    var scoreData: ScoreData { get }
}

protocol ScoreUpdating {
    func addScore(score: Int) -> Void
}

extension CDLevel {
    public var id: String {
        get { id_! }
        set { id_ = newValue}
    }
        
    var scores: [Int] {
        get { scores_ ?? [] }
        set { scores_ = newValue }
    }
    
    var audioMetadata: [AudioMetadata] {
        (audioSources_ ?? []).compactMap { ($0 as? AudioSource)?.asMetadata }
    }
    
    var difficulty: LevelDifficulty {
        get { LevelDifficulty(rawValue: Int(difficulty_))! }
        set { difficulty_ = Int16(newValue.rawValue) }
    }
    
    var number: Int {
        get { Int(number_) }
        set { number_ = Int64(newValue) }
    }
    
    var starScores: [Int] {
        get { starScores_ ?? [] }
        set { starScores_ = newValue }
    }
    
    var scoreData: ScoreData {
        ScoreData(starScores: starScores, scores: scores)
    }
    
    func addScore(score: Int) {
        scores.append(score)
        try! managedObjectContext?.save() // TODO: Force try for testing only
    }
}


