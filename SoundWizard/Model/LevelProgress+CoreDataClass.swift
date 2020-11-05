//
//  LevelProgress+CoreDataClass.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/3/20.
//
//

import Foundation
import CoreData

@objc(LevelProgress)
public class LevelProgress: NSManagedObject {
    
    var topScore: Int? {
        return scores.sorted().last
    }

}
