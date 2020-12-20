//
//  EQDetectiveLevel+BundleLevels.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/11/20.
//

import CoreData

// MARK: Bundle Levels Core Data Importing

extension EQDetectiveLevel {
    
    private enum DefaultsKey {
        static let bundleLevelsAreInDatabase = "bundleEQDetectiveLevelsAreInDatabase"
    }
    
    private static var defaults: DefaultsStore { UserDefaults.standard }
    
    private static var bundleLevelsAreInDatabase: Bool {
        get { defaults.optionalBool(forKey: DefaultsKey.bundleLevelsAreInDatabase) ?? false }
        set { defaults.setValue(newValue, forKey: DefaultsKey.bundleLevelsAreInDatabase) }
    }
    
    // MARK: - Initializer
    
    convenience init(context: NSManagedObjectContext,
                     number: Int,
                     isStock: Bool,
                     difficulty: LevelDifficulty,
                     bandFocus: BandFocus,
                     filterGainDB: Float,
                     filterQ: Float,
                     starScores: [Int],
                     audioSources: [AudioSource]) {
        self.init(context: context)
        self.id = EQDLevel.makeID(isStock: isStock, number: number, audioSources: audioSources.map { $0.asMetadata })
        self.number = number
        self.isStock = isStock
        self.difficulty = difficulty
        self.bandFocus = bandFocus
        self.filterGainDB = filterGainDB
        self.filterQ = filterQ
        self.starScores = starScores
        
        audioSources.forEach { addToAudioSources_($0) }
    }
    
    // MARK: - Bundle levels constuctor
    
    class func storeBundleLevelsIfNeeded(context: NSManagedObjectContext) {
        guard !bundleLevelsAreInDatabase else { return }
        
        var index = 1
        let context = CoreDataManager.shared.container.viewContext
        for source in AudioSource.allSources(context: context) {
            for focus in BandFocus.allCases {
                for difficulty in LevelDifficulty.allCases {
                    for gain in gainValues(for: difficulty) {
                        let _ = EQDetectiveLevel(
                            context: context,
                            number: index,
                            isStock: true,
                            difficulty: difficulty,
                            bandFocus: focus,
                            filterGainDB: gain,
                            filterQ: qValue(for: difficulty, gain: gain),
                            starScores: starScores(for: difficulty),
                            audioSources: [source]
                        )
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
    
    // MARK: - Helper Methods
    
    private class func starScores(for difficulty: LevelDifficulty) -> [Int] {
        switch difficulty {
        case .easy: return [300, 500, 700]
        case .moderate: return [500, 800, 1100]
        case .hard: return [600, 900, 1200]
        }
    }
    
    private class func gainValues(for difficulty: LevelDifficulty) -> [Float] {
        switch difficulty {
        case .easy: return [8]
        case .moderate: return [6, -16]
        case .hard: return [4, -12]
        }
    }
    
    private class func qValue(for difficulty: LevelDifficulty, gain: Float) -> Float {
        let boost = gain > 0
        switch difficulty {
        case .easy: return boost ? 8 : 6
        case .moderate: return boost ? 6 : 2
        case .hard: return boost ? 4 : 4
        }
    }
   
}
