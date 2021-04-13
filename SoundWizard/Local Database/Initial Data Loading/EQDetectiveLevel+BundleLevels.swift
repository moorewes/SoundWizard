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
                     difficulty: LevelDifficulty,
                     bandFocus: BandFocus,
                     filterGainDB: Double,
                     filterQ: Double,
                     starScores: [Int],
                     audioSources: [AudioSource]) {
        self.init(context: context)
        self.id = EQDLevel.makeStockID(number: number, audioSources: audioSources.map { $0.asMetadata })
        self.number = number
        self.difficulty = difficulty
        self.bandFocus = bandFocus
        self.filterGainDB = filterGainDB
        self.filterQ = filterQ
        self.starScores = starScores
        audioSources.forEach { addToAudioSources_($0) }
    }
    
    // MARK: - Bundle levels constuctor
    
    @discardableResult
    class func storeBundleLevelsIfNeeded(context: NSManagedObjectContext) -> [EQDetectiveLevel] {
        guard !bundleLevelsAreInDatabase else { return [] }
        
        var levels = [EQDetectiveLevel]()
        let context = CoreDataManager.shared.container.viewContext
        for source in AudioSource.allSources(context: context) {
            for focus in BandFocus.allCases {
                for difficulty in LevelDifficulty.allCases {
                    for gain in gainValues(for: difficulty) {
                        levels.append(
                            EQDetectiveLevel(
                                context: context,
                                number: levels.count + 1,
                                difficulty: difficulty,
                                bandFocus: focus,
                                filterGainDB: gain,
                                filterQ: qValue(for: difficulty, gain: gain),
                                starScores: starScores(for: difficulty),
                                audioSources: [source]
                            )
                        )
                    }
                }
            }
        }
        
        do {
            try context.save()
            print("Stored bundle levels, count: \(context.registeredObjects.count)")
            bundleLevelsAreInDatabase = true
            return levels
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    // MARK: - Helper Methods
    
    private class func starScores(for difficulty: LevelDifficulty) -> [Int] {
        switch difficulty {
        case .easy, .custom: return [300, 500, 700]
        case .moderate: return [500, 800, 1100]
        case .hard: return [600, 900, 1200]
        }
    }
    
    private class func gainValues(for difficulty: LevelDifficulty) -> [Double] {
        switch difficulty {
        case .easy, .custom: return [8]
        case .moderate: return [6, -16]
        case .hard: return [4, -12]
        }
    }
    
    private class func qValue(for difficulty: LevelDifficulty, gain: Double) -> Double {
        let boost = gain > 0
        switch difficulty {
        case .easy, .custom: return boost ? 8 : 6
        case .moderate: return boost ? 6 : 2
        case .hard: return boost ? 4 : 4
        }
    }
}

// MARK: ID Factory

private extension EQDLevel {
    static func makeStockID(number: Int, audioSources: [AudioMetadata]) -> String {
        let sourceString = audioSources.count == 1 ?
                            audioSources.first!.name :
                            "multipleAudioSources"
        
        return "\(Game.eqDetective.id).stock.\(number).\(sourceString)"
    }
}
