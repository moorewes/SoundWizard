//
//  Scratchpad.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/3/20.
//

import SwiftUI
import AudioKit

struct Scratchpad: View {
    
    var player: AudioPlayer
    var filter: EqualizerFilter
    var dryWetMixer: DryWetMixer!
    var engine: AudioEngine
//
//    @State var mix: Float = 0 {
//        didSet {
//            mixer.balance = mix
//        }
//    }
    
    init() {
        player = AudioPlayer()
        filter = EqualizerFilter(player, centerFrequency: 2000, bandwidth: 1000, gain: 2)
        dryWetMixer = DryWetMixer(player, filter)
        engine = AudioEngine()
        engine.output = dryWetMixer
        try? engine.start()
        let url = AudioFileManager.shared.url(filename: "Pink.aif", isStock: true)
        player.buffer = Cookbook.buffer(for: url)
        player.start()
    }
    
    var body: some View {
        Button("toggle") {
         //   mixer.balance = mixer.balance == 1 ? 0 : 1
        }
    }
}

struct Scratchpad_Previews: PreviewProvider {
    static var previews: some View {
        Scratchpad()
            .preferredColorScheme(.dark)
    }
}
