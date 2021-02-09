//
//  AuditionState.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import Foundation

enum AuditionState: UIDescribing, CaseIterable {
    case before
    case after
    
    var uiDescription: String {
        switch self {
        case .before:
            return "Before"
        case .after:
            return "After"
        }
    }
}
