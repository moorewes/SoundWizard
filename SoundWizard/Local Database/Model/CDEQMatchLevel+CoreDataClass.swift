//
//  CDEQMatchLevel+CoreDataClass.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/30/20.
//
//

import Foundation
import CoreData

@objc(CDEQMatchLevel)
public class CDEQMatchLevel: NSManagedObject, CDLevel {
    let game: Game = .eqMatch
    
    var bandCount: BandCount {
        get { BandCount(rawValue: Int(bandCount_))! }
        set { bandCount_ = Int16(newValue.rawValue) }
    }
    
    var bandFocus: BandFocus {
        get { BandFocus(rawValue: Int(bandFocus_))! }
        set { bandFocus_ = Int16(newValue.rawValue) }
    }
    
    var mode: EQMatchLevel.Mode {
        get { EQMatchLevel.Mode(rawValue: Int(mode_))! }
        set { mode_ = Int16(newValue.rawValue) }
    }
    
    var format: EQMatchLevel.Format {
        get {
            EQMatchLevel.Format(mode: mode, bandCount: bandCount, bandFocus: bandFocus)
        }
        set {
            bandCount = newValue.bandCount
            bandFocus = newValue.bandFocus
            mode = newValue.mode
        }
    }
}

// MARK: - Fetching

extension CDEQMatchLevel {
    static func levels(matching predicate: NSPredicate? = nil, context: NSManagedObjectContext) -> [CDEQMatchLevel] {
        let request: NSFetchRequest<CDEQMatchLevel> = CDEQMatchLevel.fetchRequest()
        request.predicate = predicate
        request.relationshipKeyPathsForPrefetching = ["audioSources_"]
        request.sortDescriptors = [NSSortDescriptor(key: "number_", ascending: true)]
        do {
            return try context.fetch(request)
        } catch {
            fatalError("Couldn't fetch levels, \(error.localizedDescription)")
        }
    }
    
    static func level(_ number: Int, context: NSManagedObjectContext) -> CDEQMatchLevel? {
        let request: NSFetchRequest<CDEQMatchLevel> = CDEQMatchLevel.fetchRequest()
        request.predicate = NSPredicate(format: "number_ = %ld", number)
        do {
            return try context.fetch(request).first
        } catch {
            fatalError("Couldn't fetch levels, \(error.localizedDescription)")
        }
    }
    
}

// MARK: - Database Level Conformance

extension CDEQMatchLevel: DatabaseLevel {
    static func createNew(level: EQMatchLevel, audioSources: [AudioSource], context: NSManagedObjectContext) {
        let result = CDEQMatchLevel(context: context)
        result.id = level.id
        result.number = level.number
        result.difficulty = level.difficulty
        result.starScores = level.scoreData.starScores
        result.format = level.format
        result.staticFrequencies = level.staticFrequencies
        result.staticGainValues = level.staticGainValues
        audioSources.forEach { result.addToAudioSources_($0) }
    }
    
    typealias LevelType = EQMatchLevel
    typealias AudioSourceType = AudioSource
    typealias ObjectContext = NSManagedObjectContext
    
    var level: EQMatchLevel {
        EQMatchLevel(id: id, number: number, audioMetadata: audioMetadata, difficulty: difficulty, format: format, scoreData: scoreData)
    }
    
    @discardableResult
    static func createNew(level: EQMatchLevel, audioSources: [AudioSource], context: NSManagedObjectContext) -> CDEQMatchLevel {
        let result = CDEQMatchLevel(context: context)
        result.id = level.id
        result.number = level.number
        result.difficulty = level.difficulty
        result.starScores = level.scoreData.starScores
        result.format = level.format
        result.staticFrequencies = level.staticFrequencies
        result.staticGainValues = level.staticGainValues
        audioSources.forEach { result.addToAudioSources_($0) }
        
        return result
    }
    
}
