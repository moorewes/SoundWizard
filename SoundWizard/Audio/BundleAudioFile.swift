//
//  AudioFile.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/5/20.
//

import Foundation

struct BundleAudioFile {
    
    let name: String
    let id: String
    let filename: String
    let fileExtension: String
    
    var fullFilename: String {
        return filename + "." + fileExtension
    }
    
    var url: URL? {
        Bundle.main.url(forResource: filename, withExtension: fileExtension)!
    }
    
    private init(name: String, filename: String, fileExtension: String) {
        self.name = name
        self.id = "Stock." + name
        self.filename = filename
        self.fileExtension = fileExtension
    }
    
}

extension BundleAudioFile {
    
    static let allFiles: [BundleAudioFile] = [
        BundleAudioFile(name: "Pink Noise", filename: "Pink", fileExtension: "aif"),
        BundleAudioFile(name: "Acoustic Drums", filename: "Drums", fileExtension: "wav"),
        BundleAudioFile(name: "Aero", filename: "Aero", fileExtension: "wav"),
        BundleAudioFile(name: "Asia", filename: "Asia", fileExtension: "wav"),
        BundleAudioFile(name: "Brick", filename: "Brick", fileExtension: "wav"),
        BundleAudioFile(name: "Cry", filename: "Cry", fileExtension: "wav"),
        BundleAudioFile(name: "Dawn", filename: "Dawn", fileExtension: "wav"),
    ]
    
}

