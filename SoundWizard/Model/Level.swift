//
//  Level.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/2/20.
//

import Foundation

protocol Level {
    var numberOfTurns: Int { get }
    var levelNumber: Int { get }
    var audioSource: AudioSource { get }
    var scores: (oneStar: Int, twoStar: Int, threeStar: Int) { get }
    var userScore: Int { get set }
    var starsEarned: Int { get }
}
