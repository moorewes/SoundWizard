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

extension Collection where Element == Level {
    
    var stars: StarProgress {
        let total = self.count * StarProgress.levelMax
        let earned = self.reduce(0) { $0 + $1.scoreData.starsEarned }
        return StarProgress(total: total, earned: earned)
    }
    
}

extension Collection where Element: LevelVariant {
    
    var stars: StarProgress {
        let total = self.count * StarProgress.levelMax
        let earned = self.reduce(0) { $0 + $1.scoreData.starsEarned }
        return StarProgress(total: total, earned: earned)
    }
    
}
