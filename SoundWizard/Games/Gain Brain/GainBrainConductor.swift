//
//  GainBrainConductor.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/10/21.
//

import Foundation
import AudioKit

class GainBrainConductor: SinglePlayerGameConductor {
    private var wetFader: Fader!
    private var mixer: DryWetMixer!
    
    override init(audio: [AudioMetadata]) {
        super.init(audio: audio)
        
        wetFader = Fader(player)
        mixer = DryWetMixer(player, wetFader)
        outputFader = Fader(mixer)
        masterConductor.patchIn(self)
    }
    
    func setDryWet(wet: Bool) {
        let value: AUValue = wet ? 1 : 0
        mixer.$balance.ramp(to: value, duration: rampTime)
    }
    
    func setWetGain(_ gain: Double) {
        let auValue = Gain(dB: gain).auValue
        wetFader.leftGain = auValue
        wetFader.rightGain = auValue
    }
}
