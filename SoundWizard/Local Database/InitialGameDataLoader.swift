//
//  InitialGameDataLoader.swift
//  SoundWizard
//
//  Created by Wes Moore on 4/12/21.
//

import Foundation
import CoreData

struct InitialDataLoader {
    static func createNewUser(in context: NSManagedObjectContext) -> User {
        let gameData = GameData(context: context)
        
        EQDetectiveLevel.storeBundleLevelsIfNeeded(context: context)
            .forEach(gameData.addToEqdLevels_)
        
        CDEQMatchLevel.storeBundleLevelsIfNeeded(context: context)
            .forEach(gameData.addToEqmLevels_)
        
        let user = User(context: context)
        user.gameData = gameData
        
        try! context.save()
        return user
    }
}
