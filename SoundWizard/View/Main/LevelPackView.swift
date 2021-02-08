//
//  LevelPackView.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/8/21.
//

import SwiftUI

struct LevelPackView: View {
    let pack: LevelPack
    let action: (Level) -> Void
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(pack.levels, id: \.id) { level in
                    Button(action: {
                        action(level)
                    }, label: {
                        LargeLevelCell(level)
                    })
                }
            }
        }
    }
}
