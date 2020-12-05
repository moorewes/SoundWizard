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
    
    private init(named name: String, description: String, withExtension ext: String = "wav") {
        url = Bundle.main.url(forResource: name, withExtension: ext)!
        self.description = description
}
    
    static var pinkNoise: Self {
        AudioSource(named: "Pink", description: "Pink Noise", withExtension: "aif")
    }
    
    static var acousticDrums: Self {
        AudioSource(named: "Drums", description: "Acoustic Drums")
    }
    
    static var aero: Self {
        AudioSource(named: "Aero", description: "Aero")
    }
    
    static var asia: Self {
        AudioSource(named: "Asia", description: "Asia")
    }
    
    static var brick: Self {
        AudioSource(named: "Brick", description: "Brick")
    }
    
    static var cry: Self {
        AudioSource(named: "Cry", description: "Cry")
    }
    
    static var dawn: Self {
        AudioSource(named: "Dawn", description: "Dawn")
    }
    
    static var all: [Self] {
        return [.pinkNoise, .acousticDrums, .aero, .asia, .brick, .cry, .dawn]
    }

    
}
