//
//  EQMatchLevelStore.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/30/20.
//

import SwiftUI

class EQMatchLevelStore: ObservableObject {
    @Published var levels: [EQMatchLevel]
    @Published var difficultySelection: LevelDifficulty = .easy
    @Published var bandCountSelection: BandCount = .single
    @Published var modeSelection: EQMatchLevel.Mode = .free
    
    func filteredLevels(with focus: BandFocus) -> [EQMatchLevel] {
        let format = EQMatchLevel.Format(mode: modeSelection, bandCount: bandCountSelection, bandFocus: focus)
        return levels.filter { $0.format == format && $0.difficulty == difficultySelection }
    }
    
    init(levels: [EQMatchLevel]) {
        self.levels = levels
    }
    
    // TODO: Deinit called when game shell starts
    deinit {
        print("deinit eqmatchelevelstore")
    }    
}
