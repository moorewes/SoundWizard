//
//  EQMatchInstructionView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import SwiftUI

struct EQMatchInstructionView: View {
    let level: EQMatchLevel
    
    var body: some View {
        HStack {
            VStack {
                Text(level.audioSourceDescription).padding(5)
                Text(level.format.bandCount.uiDescription).padding(5)
                Text(frequencyDescription).padding(5)
                Text(self.gainDescription).padding(5)
            }
            .font(.std(.subheadline))
        }
    }
    
    var frequencyDescription: String {
        "Frequency: " + (level.format.mode != .fixedFrequency ? "Free" : "Fixed")
    }
    var gainDescription: String {
        "Gain: " + (level.format.mode != .fixedGain ? "Free" : "Fixed")
    }
}

struct EQMatchInstructionView_Previews: PreviewProvider {
    static var previews: some View {
        EQMatchInstructionView(level: TestData.eqMatchLevel)
    }
}
