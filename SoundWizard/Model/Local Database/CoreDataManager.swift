//
//  UserProgressManager.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/3/20.
//

import Foundation
import CoreData

class CoreDataManager {
    
    // MARK: - Shared Instance
    
    static let shared = CoreDataManager()
    
    // MARK: - Properties
    
    var viewContext: NSManagedObjectContext { container.viewContext }
    var container: NSPersistentContainer
    
    // MARK: Internal
    
    // MARK: Private
    
    private let storeName = "SoundWizard"
        
    // MARK: - Initializers
    
    init() {
        self.container = NSPersistentContainer(name: storeName)
        setupPersistentContainer()
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func allEQDLevels() -> [Level] {
        EQDetectiveLevel.levels(context: viewContext).map { $0.level }
    }
    
    func loadInitialLevels() {
        EQDetectiveLevel.storeBundleLevelsIfNeeded(context: container.viewContext)
    }
    
    func audioSources(for metadata: [AudioMetadata]) -> [AudioSource] {
        let request: NSFetchRequest<AudioSource> = AudioSource.fetchRequest()
        let ids = metadata.map { $0.id }
        request.predicate = NSPredicate(format: "id_ in %@", argumentArray: ids)
        request.sortDescriptors = [NSSortDescriptor(key: "id_", ascending: true)]
        do {
            return try viewContext.fetch(request)
        } catch let error {
            print(error.localizedDescription)
            return []
        }
        
    }
        
    func save() {
        guard container.viewContext.hasChanges else { return }
        do {
            try container.viewContext.save()
            print("Saved Level Progress")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Private
    
    private func setupPersistentContainer() {
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    private func storeObject(matching level: Level) -> EQDetectiveLevel? {
        let levels = viewContext.registeredObjects
                        .compactMap { $0 as? EQDetectiveLevel }
                        .filter { $0.id == level.id }
        if let level = levels.first {
            return level
        } else {
            return EQDetectiveLevel.level(level.number)
        }
    }
    
    
}

extension CoreDataManager: LevelFetching {
    
    func fetchLevels(for game: Game) -> [Level] {
        switch game {
        case .eqDetective:
            return allEQDLevels()
        }
    }
    
}

extension CoreDataManager: LevelStoring {
    
    func add(level: Level) {
        if let level = level as? EQDLevel {
            EQDetectiveLevel.createNew(level: level,
                                       audioSources: audioSources(for: level.audioMetadata),
                                       context: viewContext)
        }
    }
    
    func update(level: Level) {
        guard let score = level.scoreData.scores.last else { return }
        guard let storageLevel = storeObject(matching: level) else {
            fatalError("couldn't find matching core data object to update")
        }
        storageLevel.addScore(score: score)
    }
    
    func delete(level: Level) {
        
    }
}
