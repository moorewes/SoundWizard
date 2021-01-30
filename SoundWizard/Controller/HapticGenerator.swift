//
//  HapticGenerator.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/18/20.
//

import CoreHaptics
import AVFoundation

class HapticGenerator {
    static let main = HapticGenerator()
    
    private var engine: CHHapticEngine!
    private var supportsHaptics = false
    
    private init() {
        let hapticCapability = CHHapticEngine.capabilitiesForHardware()
        supportsHaptics = hapticCapability.supportsHaptics
        
        guard supportsHaptics else { return }
        
        do {
            let session = AVAudioSession.sharedInstance()
            engine = try CHHapticEngine(audioSession: session)
            engine.resetHandler = handleEngineReset
            engine.stoppedHandler = handleEngineStop
        } catch {
            supportsHaptics = false
        }
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func fire(successLevel: ScoreSuccess) {
        guard supportsHaptics else { return }
        
        let name = fileName(for: successLevel)
        playHapticsFile(named: name)
    }
    
    // MARK: Private
    
    private func playHapticsFile(named filename: String) {
        guard let path = Bundle.main.path(forResource: filename, ofType: "ahap") else {
            return
        }
        
        do {
            try engine?.start()
            try engine?.playPattern(from: URL(fileURLWithPath: path))
        } catch {
            print("An error occured playing \(filename): \(error).")
        }
    }
    
    private func fileName(for successLevel: ScoreSuccess) -> String {
        switch successLevel {
        case .perfect:
            return "Perfect"
        case .great:
            return "Great"
        case .fair:
            return "Good"
        case .failed, .justMissed:
            return "Failure"
        }
    }
    
    private func handleEngineReset() {
        print("Engine reset")
        do {
            try engine?.start()
        } catch {
            print("An error occured starting engine: \(error).")
        }
    }
    
    private func stopEngine() {
        engine.stop(completionHandler: nil)
    }
    
    private func handleEngineStop(reason: CHHapticEngine.StoppedReason) {
        print("Engine stopped due to: \(reason.rawValue)")
        switch reason {
        case .audioSessionInterrupt:
            print("audio session interrupt")
        case .engineDestroyed:
            print("engine destroyed")
        default:
            break
        }
    }
}
