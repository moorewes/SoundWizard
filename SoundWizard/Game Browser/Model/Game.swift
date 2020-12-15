//
//  Game.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import Foundation
import UIKit

enum Game: Int, CaseIterable, Identifiable {
    
    static let starCount = 3
    
    case eqDetective = 0

    var id: Int { return self.rawValue }

    var name: String {
        switch self {
        case .eqDetective: return "EQ Detective"
        }
    }
    
}


