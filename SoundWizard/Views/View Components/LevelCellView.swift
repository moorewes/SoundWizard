//
//  LevelCellView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/24/20.
//

import SwiftUI

struct LevelCellView: View {
    let title: String
    let stars: StarProgress
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                
                Text(title)
                    .font(.std(.footnote))
                    .foregroundColor(.teal)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)
                    .position(titlePosition(in: geometry.size))
                
                Spacer()
                
                starsView
                    .padding(.bottom, 4)
                
                Spacer()
            }
        }
    }
    
    var starsView: some View {
        HStack {
            ForEach(0..<stars.total) { i in
                AnimatedStar(filled: stars.earned > i, animated: false)
                    .font(.system(size: 12))
            }
        }
    }
    
    func titlePosition(in size: CGSize) -> CGPoint {
        return CGPoint(x: size.width / 2, y: size.height / 4)
    }
}

extension LevelCellView {
    init(_ level: Level) {
        self.title = level.audioSourceDescription
        self.stars = level.stars
    }
}

struct LevelCellView_Previews: PreviewProvider {
    static var previews: some View {
        LevelCellView(title: "Drums", stars: StarProgress(total: 3, earned: 1))
            .frame(width: 80, height: 80, alignment: .center)
    }
}
