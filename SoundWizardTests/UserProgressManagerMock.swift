//
//  UserProgressManagerMock.swift
//  SoundWizardTests
//
//  Created by Wes Moore on 11/6/20.
//

@testable import SoundWizard
import Foundation
import CoreData

class UserProgressManagerMock: UserProgressManager {
    
    override init() {
        super.init()
        
        // Use memory store type for speed while testing
        let persistentStoreDescription = NSPersistentStoreDescription()
        persistentStoreDescription.type = NSInMemoryStoreType
        
        let container = NSPersistentContainer(name: "UserGameData")
        
        container.persistentStoreDescriptions = [persistentStoreDescription]
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        self.container = container
    }
    
}

