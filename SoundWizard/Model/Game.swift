//
//  Game.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import Foundation
import UIKit

enum Game: Int {
    case eqDetective = 0
    
    var id: Int { return self.rawValue }
    
    var name: String {
        switch self {
        case .eqDetective: return "EQ Detective"
        }
    }
    
    var levels: [Level] {
        switch self {
        case .eqDetective:
            return EQDetectiveLevel.levels
        }
    }
    
    static var count: Int { return 1 }

}
