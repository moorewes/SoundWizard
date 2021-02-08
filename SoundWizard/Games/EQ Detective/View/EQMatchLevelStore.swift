//
//  EQMatchLevelStore.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/30/20.
//

import SwiftUI

class EQMatchLevelStore: ObservableObject, LevelBrowsingStore {
    @Published var levels: [EQMatchLevel]
    
    func filteredLevels(format: EQMatchLevel.Format) -> [EQMatchLevel] {
        levels.filter {
            $0.format == format
        }
    }
    
    init(levels: [EQMatchLevel]) {
        self.levels = levels
    }
}
