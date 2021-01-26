//
//  ItemCell.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/25/21.
//

import SwiftUI

struct ItemCell<Content: View>: View {
    let content: () -> Content
    
    var body: some View {
        content()
            .font(.std(.footnote))
            .multilineTextAlignment(.center)
            .padding()
            .squareFrame(length: packCellLength)
            .background(Color.secondaryBackground)
            .cornerRadius(cornerRadius)
            .padding(.horizontal, horizontalPadding)
    }
    
    // Design Constants
    private let cornerRadius: CGFloat = 20
    private let packCellLength: CGFloat = 100
    private let horizontalPadding: CGFloat = 10
}

struct ItemCell_Previews: PreviewProvider {
    static var previews: some View {
        ItemCell {
            VStack {
                Text("toptioiiieowi")
                Spacer()
                Text("middle")
                    .foregroundColor(.accentColor)
                Spacer()
                HStack {
                    ForEach(0..<StarProgress.levelMax) { index in
                        StarImage()
                    }
                }
            }
        }
    }
}
