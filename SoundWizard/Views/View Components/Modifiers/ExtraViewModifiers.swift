//
//  ExtraViewModifiers.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/8/21.
//

import SwiftUI

extension View {
    func squareFrame(length: CGFloat) -> some View {
        self.frame(width: length, height: length, alignment: .center)
    }
}
