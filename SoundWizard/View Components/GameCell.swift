//
//  GameCell.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/15/20.
//

import SwiftUI

struct GameItem: Identifiable {
    var name: String
    var stars: StarProgress
    var levels: [Level]
    
    var id: String { name }
}

struct GameCell: View {
    var game: GameItem
    
    var body: some View {
        HStack {
            Text(game.name)
                .font(.std(.headline))
                .foregroundColor(.teal)
                .padding(.vertical, 30)
            
            Spacer()
            
            Star(filled: true, animated: false)
                .font(.system(size: 14))
            
            Text(game.stars.formatted)
                .font(.mono(.subheadline))
                .foregroundColor(.lightGray)
                .padding(.trailing, 15)
        }
    }
}
