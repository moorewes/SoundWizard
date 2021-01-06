//
//  DetailRow.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/5/21.
//

import SwiftUI

struct DetailRow<V: View>: View {
    let title: String
    let content: () -> V
    var body: some View {
        HStack {
            Text(title)
                .font(.std(.subheadline))
                .padding(.trailing)
            content()
        }
        .padding()
    }
}
