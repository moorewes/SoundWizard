//
//  EQDetectiveRoundData.swift
//  AudioKitExperiments
//
//  Created by Wes Moore on 10/28/20.
//

import Foundation

struct EQDetectiveRoundData {
    var filterGain: Float = 6
    var filterQ: Float = 2
    var roundCount: Int = 12
    var octaveErrorRange: Float = 2
    
    var averageOctaveError: Float?
    var score: Float = 0
}