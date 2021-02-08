//
//  SectionHeader.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/16/20.
//

import SwiftUI

struct LevelListHeader: View {
    let title: String
    let stars: StarProgress
    
    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(title)
                .font(.std(.callout))
                .foregroundColor(.white)
            
            AnimatedStar(filled: true, animated: false)
                .font(.system(size: 14))
                .padding(.leading, 10)
            
            Text(stars.uiDescription)
                .font(.mono(.subheadline))
                .foregroundColor(.lightGray)
            
            Spacer()
        }
        .padding(.bottom, 10)
        .padding(.leading)
    }
}

struct LevelListHeader_Previews: PreviewProvider {
    static var previews: some View {
        LevelListHeader(title: "Mids", stars: StarProgress(total: 30, earned: 15))
    }
}
