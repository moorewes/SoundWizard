//
//  EQMatchInstructionView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import SwiftUI

struct EQMatchInstructionView: View {
    let level = EQMatchLevel(number: 1, audioSource: .acousticDrums, difficulty: .easy)
    
    var body: some View {
        EQDetectiveInstructionView(level: EQDetectiveLevel.level(1)!)
    }
}

struct EQMatchInstructionView_Previews: PreviewProvider {
    static var previews: some View {
        EQMatchInstructionView()
    }
}
