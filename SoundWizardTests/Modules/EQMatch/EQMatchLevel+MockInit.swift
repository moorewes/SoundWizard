//
//  EQMatchLevel+MockInit.swift
//  SoundWizardTests
//
//  Created by Wes Moore on 1/4/21.
//

@testable import SoundWizard
import Foundation

struct EQMatchLevelBuilder {
    static func level(difficulty: LevelDifficulty = .easy,
                      mode: EQMatchLevel.Mode = .free,
                      bandCount: Int = 2,
                      bandFocus: BandFocus = .all,
                      fixedFreqs: [Frequency]? = nil,
                      fixedGains: [Double]? = nil) -> EQMatchLevel {
        EQMatchLevel(
            id: "",
            number: 1,
            audioMetadata: [audioMetadata],
            difficulty: difficulty,
            format: EQMatchLevel.Format(mode: mode,
                                        bandCount: BandCount(rawValue: bandCount)!,
                                        bandFocus: bandFocus),
            scoreData: EQMatchLevel.initialScoreData(difficulty: difficulty),
            staticFrequencies: fixedFreqs,
            staticGainValues: fixedGains)
    }
    
    static var audioMetadata = AudioMetadata(
        id: "stock.Pink Noise",
        name: "Pink Noise",
        filename: "Pink.aif",
        isStock: true,
        url: AudioFileManager.shared.url(filename: "Drums.wav", isStock: true)
    )
}
