//
//  UserProgressManager.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/3/20.
//

import Foundation
import CoreData

class UserProgressManager {
    
    // MARK: - Shared Instance
    
    static let shared = UserProgressManager()
    
    // MARK: - Properties
    
    var container: NSPersistentContainer
    
    // MARK: Internal
    
    // MARK: Private
    
    // MARK: - Initializers
    
    init() {
        self.container = NSPersistentContainer(name: "UserGameData")
        setupPersistentContainer()
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func progress(for game: Game) -> [LevelProgress] {
        let fetchRequest: NSFetchRequest<LevelProgress> = LevelProgress.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "gameID == %ld", game.id)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "level", ascending: true)]
        
        do {
            let results = try container.viewContext.fetch(fetchRequest)
            return results
        } catch {
            fatalError("Failed to fetch entities: \(error)")
        }
    }
    
    func progress(for level: Level) -> LevelProgress {
        let fetchRequest: NSFetchRequest<LevelProgress> = LevelProgress.fetchRequest()
        let gamePredicate = NSPredicate(format: "gameID == %ld", level.game.id)
        let levelPredicate = NSPredicate(format: "level == %ld", level.levelNumber)
        let andPredicate = NSCompoundPredicate(type: .and, subpredicates: [gamePredicate, levelPredicate])
        fetchRequest.predicate = andPredicate
        
        do {
            let objects = try container.viewContext.fetch(fetchRequest)
            return objects.first ?? createProgress(for: level)
        } catch {
            fatalError("Failed to fetch entities: \(error)")
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
    
    private func createProgress(for level: Level) -> LevelProgress {
        let progress = LevelProgress(context: container.viewContext)
        progress.gameID = level.game.id
        progress.level = level.levelNumber
        progress.gameName = level.game.name
        
        return progress
    }
    
}
