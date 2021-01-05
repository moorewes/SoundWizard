//
//  BandCount.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/4/21.
//

import Foundation

enum BandCount: Int, CaseIterable, UIDescribing {
    case single = 1, dual, triple
    
    var uiDescription: String {
        switch self {
        case .single: return "Single Band"
        case .dual: return "Dual Band"
        case .triple: return "Triple Band"
        }
    }
}
