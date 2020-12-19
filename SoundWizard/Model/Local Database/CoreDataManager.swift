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
    
    func allLevels() -> [Level] {
        EQDetectiveLevel.levels(context: viewContext).map { $0.level }
    }
    
    func loadInitialLevels() {
        EQDetectiveLevel.storeBundleLevelsIfNeeded(context: container.viewContext)
    }
    
    func update(from level: Level) {
        guard let score = level.scoreData.scores.last else { return }
        guard let storageLevel = storeObject(matching: level) else {
            fatalError("couldn't find matching core data object to update")
        }
        storageLevel.addScore(score: score)
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
