import AudioKit
import AVFoundation

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

class Cookbook {
    
    static func buffer(for url: URL) -> AVAudioPCMBuffer {
        let file = try! AVAudioFile(forReading: url)
        return try! AVAudioPCMBuffer(file: file)!
    }

}
