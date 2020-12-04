//
//  LevelCellView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/24/20.
//

import SwiftUI

struct LevelCellView: View {
    
    var level: Level
    var tapHandler: () -> Void
    
    var body: some View {
        ZStack {
            Color(white: 0.3, opacity: 1)
                .onTapGesture(perform: tapHandler)
            
            HStack {
                Text("\(level.levelNumber)")
                    .font(.monoSemiBold(20))
                    .foregroundColor(.teal)
                
                Spacer()
                
                
                
                VStack(alignment: .trailing) {
                    
                    Text("\(level.audioSource.description) - \(level.description)")
                        .font(.monoMedium(12))
                        .foregroundColor(.teal)
                        .offset(x: 0, y: -5)
                    
                    HStack {
                        Text("\(level.difficulty.uiDescription)")
                            .font(.monoMedium(12))
                            .foregroundColor(.teal)
                            .padding(.trailing, 5)
                        ForEach(0..<3) { i in
                            Image(systemName: "star.fill")
                                .foregroundColor(level.progress.starsEarned > i ? .yellow : .black)
                        }
                    }
                    
                    
                    
                }
                .frame(width: 200, height: 60, alignment: .trailing)
                    
                
                .offset(x: -10, y: 0)
            }
            
        }
    }
}

struct LevelCellView_Previews: PreviewProvider {
    static var previews: some View {
        LevelCellView(level: EQDetectiveLevel.level(1)!, tapHandler: {})
            
    }
}
