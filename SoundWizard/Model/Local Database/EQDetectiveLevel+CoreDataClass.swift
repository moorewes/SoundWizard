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
public final class EQDetectiveLevel: NSManagedObject, CDLevel {
    let game = Game.eqDetective
            
    var bandFocus: BandFocus {
        get { BandFocus(rawValue: Int(bandFocus_))! }
        set { bandFocus_ = Int16(newValue.rawValue) }
    }
}

// MARK: - Fetches

extension EQDetectiveLevel {
    static func levels(matching predicate: NSPredicate? = nil, context: NSManagedObjectContext) -> [EQDetectiveLevel] {
        let request: NSFetchRequest<EQDetectiveLevel> = EQDetectiveLevel.fetchRequest()
        request.predicate = predicate
        request.relationshipKeyPathsForPrefetching = ["audioSources_"]
        request.sortDescriptors = [NSSortDescriptor(key: "number_", ascending: true)]
        do {
            return try context.fetch(request)
        } catch {
            fatalError("Couldn't fetch levels, \(error.localizedDescription)")
        }
    }
    
    static func level(_ number: Int, context: NSManagedObjectContext) -> EQDetectiveLevel? {
        let request: NSFetchRequest<EQDetectiveLevel> = EQDetectiveLevel.fetchRequest()
        request.predicate = NSPredicate(format: "number_ = %ld", number)
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Couldn't fetch levels, \(error.localizedDescription)")
        }
    }
}

// MARK: DatabaseLevel Conformance

extension EQDetectiveLevel: DatabaseLevel {
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
                filterGain: Gain(dB: filterGainDB),
                filterQ: filterQ
            )
    }
    
    static func createNew(level: EQDLevel, audioSources: [AudioSource], context: NSManagedObjectContext) {
        let result = EQDetectiveLevel(context: context)
        result.id = level.id
        result.number = level.number
        result.difficulty = level.difficulty
        result.bandFocus = level.bandFocus
        result.filterGainDB = level.filterGain.dB
        result.filterQ = level.filterQ
        result.starScores = level.scoreData.starScores
        audioSources.forEach { result.addToAudioSources_($0) }
    }
}


