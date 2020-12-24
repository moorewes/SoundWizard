//
//  Cookbook.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/5/20.
//

import AudioKit
import AVFoundation

class Cookbook {
    static func buffer(for url: URL) -> AVAudioPCMBuffer {
        let file = try! AVAudioFile(forReading: url)
        return try! AVAudioPCMBuffer(file: file)!
    }
}
