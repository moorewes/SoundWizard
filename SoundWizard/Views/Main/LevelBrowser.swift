//
//  LevelBrowser.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/17/20.
//

import SwiftUI

struct LevelBrowser: View {
    @EnvironmentObject private var stateController: StateController
    var game: Game
    
    var body: some View {
        switch game {
        case .eqDetective:
            EQDetectiveLevelBrowser(levels: stateController.levels(),
                                    selectionHandler: stateController.openLevel)
        case .eqMatch:
            EQMatchLevelBrowser(levels: stateController.levels(),
                                launchAction: stateController.openLevel)
        }
    }
}

protocol LevelBrowsingStore {}
