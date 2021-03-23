//
//  GameplayView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/17/20.
//

import SwiftUI

struct GameplayView: View {
    let handler: GameHandling
    
    var body: some View {
        Game.build(handler: handler)
    }
}
