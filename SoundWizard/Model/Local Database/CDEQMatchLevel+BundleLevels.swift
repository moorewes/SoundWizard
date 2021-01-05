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
    
    class func storeBundleLevelsIfNeeded(context: NSManagedObjectContext) {
        guard !bundleLevelsAreInDatabase else { return }
        
        let sources = AudioSource.allSources(context: context)
        generateDBLevels(for: sources, context: context)
    }
    
    class func generateDBLevels(for sources: [AudioSource], context: NSManagedObjectContext) {
        var index = 1
        for source in sources {
            for focus in BandFocus.allCases {
                for mode in EQMatchLevel.Mode.allCases {
                    for bandCount in BandCount.allCases {
                        let format = EQMatchLevel.Format(mode: mode, bandCount: bandCount, bandFocus: focus)
                        let scoreData = EQMatchLevel.initialScoreData(difficulty: .easy)
                        var level = EQMatchLevel(id: "",
                                                 number: index,
                                                 audioMetadata: [],
                                                 difficulty: .easy,
                                                 format: format,
                                                 scoreData: scoreData)
                        level.setStockID(audioSources: [source])
                        CDEQMatchLevel.createNew(level: level, audioSources: [source], context: context)
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

private extension EQMatchLevel {
    mutating func setStockID(audioSources: [AudioSource]) {
        let sourceString = audioSources.count == 1 ?
            audioSources.first!.name :
            "multipleAudioSources"
        id = "stock" +
            number.description +
            difficulty.uiDescription +
            format.mode.uiDescription +
            format.bandCount.uiDescription +
            format.bandCount.uiDescription +
            sourceString
    }
}
