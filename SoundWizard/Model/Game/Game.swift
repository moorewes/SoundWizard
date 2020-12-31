//
//  Game.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import Foundation
import SwiftUI

enum Game: Int, CaseIterable, Identifiable {        
    case eqDetective = 0, eqMatch

    var id: Int { return self.rawValue }

    var name: String {
        switch self {
        case .eqDetective: return "EQ Detective"
        case .eqMatch: return "EQ Match"
        }
    }
}
