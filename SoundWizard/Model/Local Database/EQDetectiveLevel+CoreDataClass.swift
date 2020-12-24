//
//  EQDetectiveLevel+CoreDataClass.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/10/20.
//
//

import Foundation
import CoreData

@objc(EQDetectiveLevel)
public final class EQDetectiveLevel: NSManagedObject {
    static let game = Game.eqDetective
    
    lazy var scoreData = ScoreData(starScores: starScores, scores: scores)
        
    var bandFocus: BandFocus {
        get { BandFocus(rawValue: Int(bandFocus_))! }
        set { bandFocus_ = Int16(newValue.rawValue) }
    }
    
    func addScore(score: Int) {
        scoreData.addScore(score)
        scores = scoreData.scores
        try! managedObjectContext?.save()
    }
}

// MARK: - Fetches

extension EQDetectiveLevel {
    static func levels(matching predicate: NSPredicate? = nil, context: NSManagedObjectContext) -> [EQDetectiveLevel] {
        let request: NSFetchRequest<EQDetectiveLevel> = EQDetectiveLevel.fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = [NSSortDescriptor(key: "number_", ascending: true)]
        do {
            return try context.fetch(request)
        } catch {
            fatalError("Couldn't fetch levels, \(error.localizedDescription)")
        }
    }
    
    static func level(_ number: Int) -> EQDetectiveLevel? {
        let context = CoreDataManager.shared.container.viewContext
        let request: NSFetchRequest<EQDetectiveLevel> = EQDetectiveLevel.fetchRequest()
        request.predicate = NSPredicate(format: "number_ = %ld", number)
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Couldn't fetch levels, \(error.localizedDescription)")
        }
    }
}

// MARK: - Level Conformance

extension EQDetectiveLevel {
    public var id: String {
        get { id_! }
        set { id_ = newValue}
    }
        
    var scores: [Int] {
        get { scores_ ?? [] }
        set { scores_ = newValue }
    }
    
    var game: Game {
        Self.game
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
}

// MARK: LevelStorageObject Conformance

extension EQDetectiveLevel: LevelStorageObject {
    typealias LevelType = EQDLevel
    typealias AudioSourceType = AudioSource
    typealias ObjectContext = NSManagedObjectContext
    
    var level: LevelType {
            EQDLevel(
                id: id,
                game: game,
                number: number,
                difficulty: difficulty,
                audioMetadata: audioMetadata,
                scoreData: scoreData,
                bandFocus: bandFocus,
                filterGain: filterGainDB,
                filterQ: filterQ
            )
    }
    
    static func createNew(level: EQDLevel, audioSources: [AudioSource], context: NSManagedObjectContext) {
        let result = EQDetectiveLevel(context: context)
        result.id = level.id
        result.number = level.number
        result.difficulty = level.difficulty
        result.bandFocus = level.bandFocus
        result.filterGainDB = level.filterGain
        result.filterQ = level.filterQ
        result.starScores = level.scoreData.starScores
        audioSources.forEach { result.addToAudioSources_($0) }
    }
}


