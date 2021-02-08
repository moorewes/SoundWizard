//
//  HzCircleIcon.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/8/21.
//

import SwiftUI

struct HzCircleIcon: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundColor(.purple)
            Text("Hz")
                .font(.std(.subheadline))
        }
    }
}

struct HzCircleIcon_Previews: PreviewProvider {
    static var previews: some View {
        HzCircleIcon()
            .frame(width: 40, height: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
    }
}
