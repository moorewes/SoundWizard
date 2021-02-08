//
//  GameConductor.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import Foundation
import AudioKit

protocol GameConductor {
    var outputFader: Fader? { get }
    func startPlaying()
    func stopPlaying()
}
