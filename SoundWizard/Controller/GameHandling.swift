//
//  GameHandling.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/18/20.
//

import SwiftUI

protocol GameHandling {
    var level: Level { get }
    var state: GameViewState { get }
    var startHandler: GameStartHandling { get }
    var completionHandler: GameCompletionHandling { get }
}

protocol GameStartHandling {
    func startGame(practicing: Bool) -> Void
}

protocol GameCompletionHandling {
    func finishGame(score: GameScore) -> Void
    func quitGame() -> Void
}

protocol GameTransitionHandling: GameStartHandling, GameCompletionHandling {}
