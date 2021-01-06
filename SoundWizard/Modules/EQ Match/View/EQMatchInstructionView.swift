//
//  EQMatchInstructionView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/6/20.
//

import SwiftUI

// TODO: Build visual EQ plot to display level details
struct EQMatchInstructionView: View {
    let level: EQMatchLevel
    
    var body: some View {
        VStack {
            HStack {
                Text(level.audioSourceDescription)
                Spacer()
                Text(modeDescription)
            }.padding(.top, 20)
            BellPath(filters: cgFilters)
                .padding(.vertical)
            HStack {
                Text(level.difficulty.uiDescription)
                Spacer()
                Text(level.format.bandFocus.uiRangeDescription)
            }.padding(.bottom, 20)
        }
        .font(.std(.subheadline))
        .padding(.horizontal)
    }
    
    private var modeDescription: String {
        switch level.format.mode {
        case .fixedFrequency:
            return "Match Gain"
        case .fixedGain:
            return "Match Frequency"
        case .free:
            return "Match Gain & Frequency"
        }
    }
    
    private var cgFilters: CGFilters {
        var filters = EQMatchGame.SolutionGenerator(level: level).solutionTemplate
        for (i, _) in filters.enumerated() {
            filters[i].gain.dB = 1
        }
        
        return CGFilters(filters: filters,
                         frequencyRange: level.format.bandFocus.range,
                         gainRange: -5...5)
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
            .frame(width: 320, height: 300, alignment: .center)
    }
}
