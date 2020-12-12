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
public class EQDetectiveLevel: NSManagedObject {
    
    static let game = Game.eqDetective
        
    var bandFocus: BandFocus {
        get { BandFocus(rawValue: Int(bandFocus_))! }
        set { bandFocus_ = Int16(newValue.rawValue) }
    }
    
    lazy var octaveErrorRange: Octave = {
        switch difficulty {
        case .easy:
            return bandFocus.octaveSpan / 4
        case .moderate:
            return bandFocus.octaveSpan / 6
        case .hard:
            return bandFocus.octaveSpan / 8
        }
    }()

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
    
    static func level(_ number: Int) -> EQDetectiveLevel {
        let context = CoreDataManager.shared.container.viewContext
        let request: NSFetchRequest<EQDetectiveLevel> = EQDetectiveLevel.fetchRequest()
        request.predicate = NSPredicate(format: "number_ = %ld", number)
        do {
            return try context.fetch(request).first!
        } catch {
            fatalError("Couldn't fetch levels, \(error.localizedDescription)")
        }
    }
        
}

// MARK: - Level Conformance

extension EQDetectiveLevel: Level {
    
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
        get { audioSources_?.allObjects as? [AudioSource] ?? [] }
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
