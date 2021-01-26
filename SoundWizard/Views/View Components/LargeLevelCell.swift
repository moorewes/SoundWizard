//
//  LargeLevelCell.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/8/21.
//

import SwiftUI

struct LargeLevelCell: View {
    let title: String
    let audio: String
    let difficulty: String
    let stars: String
    
    var body: some View {
        VStack {
            Text(title)
                .foregroundColor(.accentColor)
                .padding()
            Text(audio)
                .padding()
            HStack {
                Text(difficulty)
                AnimatedStar(filled: true, animated: false)
                Text(stars).padding(2)
                    .foregroundColor(.accentColor)
            }
            .padding()
        }
        .font(.std(.footnote))
        .background(Color.secondaryBackground)
        .cornerRadius(20)
        
    }
}

extension LargeLevelCell {
    init(_ level: Level) {
        self.title = level.game.name
        self.audio = level.audioSourceDescription
        self.difficulty = level.difficulty.uiDescription
        self.stars = level.stars.uiDescription
    }
}

struct LargeLevelCell_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            LargeLevelCell(TestData.eqMatchLevel)
                .accentColor(.teal)
                .padding()
            LargeLevelCell(TestData.eqMatchLevel)
                .accentColor(.teal)
                .padding()
        }
        
    }
}
