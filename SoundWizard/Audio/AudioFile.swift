//
//  AudioFile.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/5/20.
//

import Foundation

struct BundleAudioFile {
    
    let name: String
    let id: Int
    let filename: String
    let fileExtension: String
    
    var fullFilename: String {
        return filename + "." + fileExtension
    }
    
    var url: URL? {
        Bundle.main.url(forResource: filename, withExtension: fileExtension)!
    }
    
    private init(name: String, id: Int, filename: String, fileExtension: String) {
        self.name = name
        self.id = id
        self.filename = filename
        self.fileExtension = fileExtension
    }
    
}

extension BundleAudioFile {
    
    static let allFiles: [BundleAudioFile] = [
        BundleAudioFile(name: "Pink Noise", id: 0, filename: "Pink", fileExtension: "aif"),
        BundleAudioFile(name: "Acoustic Drums", id: 1, filename: "Drums", fileExtension: "wav"),
        BundleAudioFile(name: "Aero", id: 2, filename: "Aero", fileExtension: "wav"),
        BundleAudioFile(name: "Asia", id: 3, filename: "Asia", fileExtension: "wav"),
        BundleAudioFile(name: "Brick", id: 4, filename: "Brick", fileExtension: "wav"),
        BundleAudioFile(name: "Cry", id: 5, filename: "Cry", fileExtension: "wav"),
        BundleAudioFile(name: "Dawn", id: 6, filename: "Dawn", fileExtension: "wav"),
    ]
    
}

