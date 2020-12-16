//
//  StarProgress.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/15/20.
//

import Foundation

struct StarProgress {
    static let levelMax = 3
    
    let total: Int
    let earned: Int
    
    var formatted: String {
        "\(earned)/\(total)"
    }
}
