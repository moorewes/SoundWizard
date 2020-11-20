//
//  GamesViewModel.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/13/20.
//

import SwiftUI

class GamesViewModel: ObservableObject {
    
    @Published var games: [Game] = Game.allCases
}
