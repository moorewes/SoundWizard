//
//  GameItem.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/15/20.
//

import SwiftUI

struct GameItem: Identifiable {
    var game: Game
    var stars: StarProgress
    
    var title: String {
        return game.name
    }
    
    var id: String {
        title
    }
 
}

struct GameCell: View {
    var game: GameItem
    
    var body: some View {
        HStack {
            Text(game.title)
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
