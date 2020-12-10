//
//  Scratchpad.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/3/20.
//

import SwiftUI

class ScratchViewModel: ObservableObject {
    @Published var score = 20000
}

struct Scratchpad: View {
    
    @ObservedObject var model = ScratchViewModel()
    
    var score: Int { model.score }
    
    var body: some View {
        VStack {
            MovingCounter(number: score, font: Font.mono(.callout))
                .animation(.easeIn)
            Spacer()
            Button("Toggle") {
                model.score += 100
            }
        }
    }
}

struct Scratchpad_Previews: PreviewProvider {
    static var previews: some View {
        Scratchpad()
            .preferredColorScheme(.dark)
    }
}
