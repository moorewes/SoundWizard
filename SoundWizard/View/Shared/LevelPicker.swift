//
//  LevelsHorizontalList.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/8/20.
//

import SwiftUI

struct LevelPicker: View {
    var levels: [Level]
    var action: (Level) -> Void
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(levels, id: \.id) { level in
                    Button(action: {
                        action(level)
                    }, label: {
                        LevelCell(level)
                    })
                    .foregroundColor(.white)
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
    
    // Design Constants
    private let cellWidth: CGFloat = 80
    private let cornerRadius: CGFloat = 15
    private let horizontalPadding: CGFloat = 5
}

struct LevelCell: View {
    let title: String
    let subtitle: String
    let starsEarned: Int
    
    var body: some View {
        ItemCell {
            VStack {
                Text(title)
                Spacer()
                Text(subtitle)
                    .foregroundColor(.swAccentColor)
                Spacer()
                HStack {
                    ForEach(0..<StarProgress.levelMax) { index in
                        StarImage(earned: starsEarned > index)
                    }
                }
            }
        }
    }
}

extension LevelCell {
    init(_ level: Level) {
        self.title = level.game.shortName
        self.subtitle = level.audioSourceDescription
        self.starsEarned = level.stars.earned
    }
}

struct LevelPicker_Previews: PreviewProvider {
    static var previews: some View {
        LevelPicker(levels: [TestData.eqdLevel], action: {_ in})
    }
}
