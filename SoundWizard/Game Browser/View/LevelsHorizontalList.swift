//
//  LevelsHorizontalList.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/8/20.
//

import SwiftUI

struct LevelsHorizontalList: View {
    
    var levels: [Level]
    var selectionHandler: (Level) -> Void
    
    init(levels: [Level], onSelect handler: @escaping (Level) -> Void) {
        self.levels = levels
        self.selectionHandler = handler
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(levels, id: \.self.id) { level in
                    Button(action: {
                        selectionHandler(level)
                    }, label: {
                        LevelCellView(level: level)
                    })
                    .frame(width: 80, height: 80, alignment: .center)
                    .cornerRadius(15)
                    .padding(.leading)
                    .padding(.trailing, -5)
                }
            }
        }
        
    }
    
}
