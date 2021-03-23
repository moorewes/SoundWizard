//
//  CDGainBrainLevel.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/12/21.
//

import Foundation
import CoreData

extension CDGainBrainLevel: CDLevel {
    var game: Game { Game.gainBrain }
}

extension CDGainBrainLevel {
    private enum DefaultsKey {
        static let bundleLevelsAreInDatabase = "bundleGainBrainLevelsAreInDatabase"
    }
    
    private static var defaults: DefaultsStore { UserDefaults.standard }
    
    private static var bundleLevelsAreInDatabase: Bool {
        get { defaults.optionalBool(forKey: DefaultsKey.bundleLevelsAreInDatabase) ?? false }
        set { defaults.setValue(newValue, forKey: DefaultsKey.bundleLevelsAreInDatabase) }
    }
    
    static func storeBundleLevelsIfNeeded(context: NSManagedObjectContext) {
        let level = CDGainBrainLevel(context: context)
        level.number = 1
        level.id = Game.gainBrain.name.idFormatted + String(level.number)
        level.difficulty = .easy
        level.scoreData = ScoreData(starScores: [1000, 2000, 3000])
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
        
    }
}
