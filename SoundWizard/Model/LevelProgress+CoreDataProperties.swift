//
//  LevelProgress+CoreDataProperties.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/3/20.
//
//

import Foundation
import CoreData


extension LevelProgress {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<LevelProgress> {
        return NSFetchRequest<LevelProgress>(entityName: "LevelProgress")
    }

    @NSManaged public var gameID: Int
    @NSManaged public var gameName: String
    @NSManaged public var scores: Array<Int>
    @NSManaged public var starsEarned: Int
    @NSManaged public var level: Int

}

extension LevelProgress : Identifiable {

}
