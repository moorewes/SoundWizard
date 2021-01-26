//
//  StarProgress.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/15/20.
//

import Foundation

struct StarProgress {
    let total: Int
    let earned: Int
}

extension StarProgress {
    static let levelMax = 3
}

extension StarProgress: UIDescribing {
    var uiDescription: String {
        "\(earned)/\(total)"
    }
}

extension StarProgress {
    init(combining stars: [StarProgress]) {
        let total = stars.reduce(0) { $0 + $1.total }
        let earned = stars.reduce(0) { $0 + $1.earned }
        
        self.init(total: total, earned: earned)
    }
}

extension Collection where Element == Level {
    var starProgress: StarProgress {
        StarProgress(combining: self.map { $0.stars })
    }
}

extension Collection where Element: Level {
    var starProgress: StarProgress {
        StarProgress(combining: self.map { $0.stars })
    }
}
