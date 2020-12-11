//
//  LevelCellView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/24/20.
//

import SwiftUI

struct LevelCellView: View {
    
    var level: Level
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color.listRowBackground.ignoresSafeArea()
                
                VStack {
                    
                    Spacer()
                    
                    Text(level.audioSourceDescription)
                        .font(.mono(.footnote))
                        .foregroundColor(.teal)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 8)
                        .position(audioNamePosition(in: geometry.size))
                    
                    Spacer()
                    
                    stars
                        .padding(.bottom, 4)
                    
                    Spacer()
                }
                
            }
        }
    }
    
    var stars: some View {
        return HStack {
        
            ForEach(0..<3) { i in
                Star(filled: level.starsEarned > i, animated: false)
                    .font(.system(size: 12))
            }
        }
    }
    
    func audioNamePosition(in size: CGSize) -> CGPoint {
        return CGPoint(x: size.width / 2, y: size.height / 4)
    }
    
    
}

struct LevelCellView_Previews: PreviewProvider {
    static var previews: some View {
        LevelCellView(level: EQDetectiveLevel.level(3))
            .frame(width: 80, height: 80, alignment: .center)
            .preferredColorScheme(.dark)
            
    }
}
