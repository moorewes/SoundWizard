//
//  SoundFXManager.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/19/20.
//

import AVFoundation

class SoundFXManager {
    
    static let main = SoundFXManager()
    
    var player: AVAudioPlayer?

    func playTurnResultFX(successLevel: ScoreSuccessLevel) {
        guard let url = turnFXURL(successLevel: successLevel) else { fatalError() }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.wav.rawValue)

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func turnFXURL(successLevel: ScoreSuccessLevel) -> URL? {
        let fileName = turnFXFilename(successLevel: successLevel)
        return Bundle.main.url(forResource: fileName, withExtension: "wav")
    }
    
    
    private func turnFXFilename(successLevel: ScoreSuccessLevel) -> String {
        switch successLevel {
        case .perfect:
            return "TurnResult_Perfect"
        case .great:
            return "TurnResult_Great"
        case .fair:
            return "TurnResult_Fair"
        case .justMissed, .failed:
            return "TurnResult_Failed"
        }
    }
}
