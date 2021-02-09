//
//  ChoiceItem.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import Foundation

struct ChoiceItem: Identifiable {
    let title: String
    var status: Status = .standby
    var action: () -> Void = {}
    var id: String { title }
}

extension ChoiceItem {
    enum Status {
        case standby
        case revealed(isCorrect: Bool)
    }
}
