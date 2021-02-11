//
//  MultipleChoiceGame+Turn.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/10/21.
//

import Foundation

//extension MultipleChoiceGameViewModel {
//    struct Turn: GameTurn {
//        let number: Int
//        let choices: [Choice]
//        var status: TurnStatus = .waitingForGuess
//        
//        var score: Score? {
//            switch status {
//            case .ended(_, let score):
//                return score
//            default:
//                return nil
//            }
//        }
//                
//        mutating func end(choice: Choice) {
//            // TODO: Score engine
//            let score = choice.isCorrect ?
//                Score(value: 100, successLevel: .perfect) :
//                Score(value: 0, successLevel: .failed)
//            
//            status = .ended(won: choice.isCorrect, score: score)
//        }
//    }
//}

enum TurnStatus {
    case waitingForGuess
    case ended(won: Bool, score: Score)
}
