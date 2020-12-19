//
//  LevelsHorizontalList.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/8/20.
//

import SwiftUI

struct LevelPicker: View {
    
    var levels: [Level]
    var selectionHandler: (Level) -> Void
    
    init(levels: [Level], onSelect handler: @escaping (Level) -> Void) {
        self.levels = levels
        self.selectionHandler = handler
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(levels) { level in
                    Button(action: {
                        selectionHandler(level)
                    }, label: {
                        LevelCellView(title: level.audioSourceDescription,
                                      stars: level.stars)
                    })
                    .frame(width: 80, height: 80, alignment: .center)
                    .cornerRadius(15)
                    .padding(.horizontal, 5)
                }
            }
            .padding(.horizontal)
        }
    }
}