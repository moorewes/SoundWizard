//
//  LevelFetching.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/19/20.
//

import Foundation
import CoreData

protocol LevelFetching {
    func fetchLevels(for game: Game) -> [Level]
}

protocol LevelStoring {
    
    func add(level: Level) -> Void
    func update(level: Level) -> Void
    func delete(level: Level) -> Void
        
}

protocol LevelStorageObject {
    associatedtype LevelType: Level
    associatedtype AudioSourceType
    associatedtype ObjectContext
    
    var level: LevelType { get }
    
    static func createNew(level: LevelType,
                          audioSources: [AudioSourceType],
                          context: ObjectContext)
}
