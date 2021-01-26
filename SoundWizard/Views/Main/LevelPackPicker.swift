//
//  LevelPackPicker.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/8/21.
//

import SwiftUI

struct LevelPackPicker<Destination: View>: View {
    let packs: [LevelPack]
    let destination: (LevelPack) -> Destination
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(packs) { pack in
                    NavigationLink(
                        destination: destination(pack),
                        label: {
                            PackCell(pack)
                                .foregroundColor(.white)
                        })
                }
            }
            .padding([.horizontal, .bottom])
        }
    }
}

struct PackCell: View {
    let title: String
    let stars: String
    
    var body: some View {
        ItemCell {
            VStack {
                Text(title)
                    .font(.std(.footnote))
                Spacer()
                HStack {
                    StarImage()
                    Text(stars)
                        .foregroundColor(.accentColor)
                }
            }
        }
    }
}

extension PackCell {
    init(_ pack: LevelPack) {
        self.title = pack.name
        self.stars = pack.levels.starProgress.uiDescription
    }
}
