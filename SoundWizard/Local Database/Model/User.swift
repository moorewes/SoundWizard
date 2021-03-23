//
//  User+CoreDataClass.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/12/21.
//
//

import Foundation
import CoreData

extension User {
    func levels(for game: Game) -> [Level] {
        switch game {
        case .eqDetective: return eqdLevels
        case .eqMatch: return eqmLevels
        case .gainBrain: return gainBrainLevels
        }
    }
    
    var eqdLevels: [EQDetectiveLevel] {
        get {
            [EQDetectiveLevel](eqdLevels_! as! Set<EQDetectiveLevel>)
        }
        set {
            eqdLevels_ = Set(newValue) as NSSet
        }
    }
    
    var eqmLevels: [CDEQMatchLevel] {
        get {
            [CDEQMatchLevel](eqmLevels_! as! Set<CDEQMatchLevel>)
        }
        set {
            eqmLevels_ = Set(newValue) as NSSet
        }
    }
    
    var gainBrainLevels: [CDGainBrainLevel] {
        get {
            [CDGainBrainLevel](gainBrainLevels_! as! Set<CDGainBrainLevel>)
        }
        set {
            gainBrainLevels_ = Set(newValue) as NSSet
        }
    }
}
