//
//  CDEQMatchLevel+BundleLevels.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/30/20.
//

import CoreData

extension CDEQMatchLevel {
    private enum DefaultsKey {
        static let bundleLevelsAreInDatabase = "bundleEQMatchLevelsAreInDatabase"
    }
    
    private static var defaults: DefaultsStore { UserDefaults.standard }
    
    private static var bundleLevelsAreInDatabase: Bool {
        get { defaults.optionalBool(forKey: DefaultsKey.bundleLevelsAreInDatabase) ?? false }
        set { defaults.setValue(newValue, forKey: DefaultsKey.bundleLevelsAreInDatabase) }
    }
    
    // MARK: - Bundle levels constuctor
    
    class func storeBundleLevelsIfNeeded(context: NSManagedObjectContext) -> [CDEQMatchLevel] {
        guard !bundleLevelsAreInDatabase else { return [] }
        
        let sources = AudioSource.allSources(context: context)
        return generateDBLevels(for: sources, context: context)
    }
    
    class func generateDBLevels(for sources: [AudioSource], context: NSManagedObjectContext) -> [CDEQMatchLevel] {
        var levels = [CDEQMatchLevel]()
        for source in sources {
            let diffs: [LevelDifficulty] = [.easy, .moderate, .hard]
            for difficulty in diffs {
                for focus in BandFocus.allCases {
                    for bandCount in BandCount.allCases {
                        let modes = EQMatchLevel.supportedModes(difficulty: difficulty, bandCount: bandCount)
                        for mode in modes {
                            let format = EQMatchLevel.Format(mode: mode, bandCount: bandCount, bandFocus: focus)
                            let scoreData = EQMatchLevel.initialScoreData(difficulty: .easy)
                            var level = EQMatchLevel(id: "",
                                                     number: levels.count + 1,
                                                     audioMetadata: [],
                                                     difficulty: difficulty,
                                                     format: format,
                                                     scoreData: scoreData)
                            level.setStockID(audioSources: [source])
                            levels.append(
                                CDEQMatchLevel.createNew(level: level, audioSources: [source], context: context)
                            )
                            
                        }
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
}

private extension EQMatchLevel {
    mutating func setStockID(audioSources: [AudioSource]) {
        let sourceString = audioSources.count == 1 ?
            audioSources.first!.name :
            "MultipleAudioSources"
        id = game.name.idFormatted +
            "Stock".idFormatted +
            number.description.idFormatted +
            difficulty.uiDescription.idFormatted +
            format.mode.uiDescription.idFormatted +
            format.bandCount.uiDescription.idFormatted +
            format.bandCount.uiDescription.idFormatted +
            sourceString.idFormatted
        id.removeLast()
    }
}

extension String {
    /// Remove whitespace and append a "."
    var idFormatted: String {
        var string = self
        string.removeAll { $0 == " " }
        string.append(".")
        return string
    }
}
