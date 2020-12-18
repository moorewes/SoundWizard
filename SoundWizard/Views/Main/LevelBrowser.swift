//
//  LevelBrowser.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/17/20.
//

import SwiftUI

struct LevelBrowser: View {
    
    var game: Game
    
    @EnvironmentObject private var stateController: StateController
    
    var body: some View {
        switch game {
        case .eqDetective:
            EQDetectiveLevelBrowser(levels: stateController.levels())
        }
    }
    
}
