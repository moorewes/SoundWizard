//
//  EQMatchGame+FilterMode.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/28/20.
//

import Foundation

extension EQMatchGame {
    enum FilterMode: String, CaseIterable, Identifiable {
        case solution, guess
        
        var id: String { rawValue }
    }
}
