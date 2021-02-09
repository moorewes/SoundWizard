//
//  MultipleChoiceGame.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import Foundation

protocol MultipleChoiceGame: GameModel {
    var auditionState: AuditionState { get set }
    var instructionText: String { get }
    var choiceItems: [ChoiceItem] { get }
}
