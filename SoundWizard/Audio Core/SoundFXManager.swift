//
//  SoundFXManager.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/19/20.
//

import AVFoundation

class SoundFXManager {
    
    static let main = SoundFXManager()
        
    private var buffers = [ScoreSuccessLevel:AVAudioPCMBuffer]()
    
    private init() {
        loadBuffers()
    }
    
    func buffer(for scoreSuccessLevel: ScoreSuccessLevel) -> AVAudioPCMBuffer {
        return buffers[scoreSuccessLevel]!
    }
    
    func buffer(for star: Int) -> AVAudioPCMBuffer {
        switch star {
        case 1:
            return buffer(for: .fair)
        case 2:
            return buffer(for: .great)
        default:
            return buffer(for: .perfect)
        }
    }
    
    private func loadBuffers() {
        ScoreSuccessLevel.allCases.forEach { buffers[$0] = turnFXBuffer(successLevel: $0) }
    }
    
    private func turnFXBuffer(successLevel: ScoreSuccessLevel) -> AVAudioPCMBuffer {
        let url = turnFXURL(successLevel: successLevel)
        let file = try! AVAudioFile(forReading: url!)
        return try! AVAudioPCMBuffer(file: file)!
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
