import AudioKit
import AVFoundation

// Helper functions

typealias AudioSource = URL

enum AudioSources {
    static let pinkNoise = Bundle.main.url(forResource: "Pink", withExtension: "aif")!
    static let drums = Bundle.main.url(forResource: "Drums", withExtension: "wav")!
}

class Cookbook {
    
    static func buffer(for url: AudioSource) -> AVAudioPCMBuffer {
        let file = try! AVAudioFile(forReading: url)
        return try! AVAudioPCMBuffer(file: file)!
    }

}
