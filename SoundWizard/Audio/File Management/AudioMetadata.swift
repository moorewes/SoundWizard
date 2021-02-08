//
//  AudioMetadata.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import Foundation
import AVFoundation

struct AudioMetadata: Identifiable, Hashable {
    var id: String
    var name: String
    var filename: String
    var isStock: Bool
    var url: URL
    
    var buffer: AVAudioPCMBuffer? {
        if let file = try? AVAudioFile(forReading: url) {
            return try? AVAudioPCMBuffer(file: file)
        } else {
            return nil
        }
    }
}

extension AudioMetadata: UIDescribing {
    var uiDescription: String { name }
}
