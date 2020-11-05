//
//  AudioSource.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/5/20.
//

import Foundation

struct AudioSource {
    
    var url: URL
    var description: String
    
    static var pinkNoise: Self {
        let url = Bundle.main.url(forResource: "Pink", withExtension: "aif")!
        return AudioSource(url: url, description: "Pink Noise")
    }
    
    static var acousticDrums: Self {
        let url = Bundle.main.url(forResource: "Drums", withExtension: "wav")!
        return AudioSource(url: url, description: "Acoustic Drums")
    }
    
}
