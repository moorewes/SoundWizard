//
//  EQMatchGameplayView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import SwiftUI

struct EQMatchGameplayView: View {
    
    @ObservedObject var game = EQMatchGame(level: EQMatchLevel.levels.first!, gameViewState: .constant(.inGame))
    
    @State var frequency: Frequency = 1000
    @State var gain: Float = 0
    
    var body: some View {
        InteractiveFilter(data: game, frequency: $frequency, gain: $gain)
            .frame(width: 320, height: 300, alignment: .center)
    }
}

struct EQMatchGameplayView_Previews: PreviewProvider {
    static var previews: some View {
        EQMatchGameplayView()
    }
}
