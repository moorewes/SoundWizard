//
//  EQDetectiveLevel+BundleLevels.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/11/20.
//

import CoreData

// MARK: Bundle Levels

extension EQDetectiveLevel {
    
    private enum DefaultsKey {
        static let bundleLevelsAreInDatabase = "bundleEQDetectiveLevelsAreInDatabase"
    }
    
    private static var defaults: DefaultsStore { UserDefaults.standard }
    
    private static var bundleLevelsAreInDatabase: Bool {
        get { defaults.optionalBool(forKey: DefaultsKey.bundleLevelsAreInDatabase) ?? false }
        set { defaults.setValue(newValue, forKey: DefaultsKey.bundleLevelsAreInDatabase) }
    }
    
    private static func starScores(for difficulty: LevelDifficulty) -> [Int] {
        switch difficulty {
        case .easy: return [300, 500, 700]
        case .moderate: return [500, 800, 1100]
        case .hard: return [600, 900, 1200]
        }
    }
    
    private static func gainValues(for difficulty: LevelDifficulty) -> [Float] {
        switch difficulty {
        case .easy: return [8]
        case .moderate: return [6, -8]
        case .hard: return [4, -6]
        }
    }
    
    private static func qValue(for difficulty: LevelDifficulty) -> Float {
        switch difficulty {
        case .easy: return 8
        case .moderate: return 6
        case .hard: return 6
        }
    }
    
    // MARK: - Bundle levels constuctor
    
    static func storeBundleLevelsIfNeeded(context: NSManagedObjectContext) {
        guard !bundleLevelsAreInDatabase else { return }
        
        let gameID = Game.eqDetective.id
        var index = 1
        let context = CoreDataManager.shared.container.viewContext
        for source in AudioSource.allSources(context: context) {
            for focus in BandFocus.allCases {
                for difficulty in LevelDifficulty.allCases {
                    let scores = starScores(for: difficulty)
                    let q = qValue(for: difficulty)
                    for gain in gainValues(for: difficulty) {
                        let level = EQDetectiveLevel(context: context)
                        level.number = index
                        level.isStock = true
                        level.id = "\(gameID).stock.\(index)"
                        level.difficulty = difficulty
                        level.bandFocus = focus
                        level.filterGainDB = gain
                        level.filterQ = q
                        level.starScores = scores
                        level.addToAudioSources_(source)
                        index += 1
                    }
                }
            }
        }
        
        do {
            try context.save()
            print("Stored bundle levels, count: \(context.registeredObjects.count)")
            bundleLevelsAreInDatabase = true
        } catch {
            print(error.localizedDescription)
        }
    }
}
