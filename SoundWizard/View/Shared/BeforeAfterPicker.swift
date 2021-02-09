//
//  BeforeAfterPicker.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import SwiftUI

struct BeforeAfterPicker: View {
    @Binding var state: AuditionState
    
    var body: some View {
        EnumPicker($state)
            .pickerStyle(SegmentedPickerStyle())
            .font(.std(.subheadline))
            .padding()
    }
}
