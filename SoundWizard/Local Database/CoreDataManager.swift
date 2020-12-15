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
    
    func loadInitialLevels() {
        EQDetectiveLevel.storeBundleLevelsIfNeeded(context: container.viewContext)        
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
    
}
