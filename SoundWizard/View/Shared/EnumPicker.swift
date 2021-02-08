//
//  EnumPicker.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/4/21.
//

import SwiftUI

struct EnumPicker<T: Hashable & CaseIterable, V: View>: View {
    @Binding var selected: T
    var cases: [T] = Array(T.allCases)
    var title: String? = nil
    let mapping: (T) -> V
    
    var body: some View {
        Picker(selection: $selected, label: Text(title ?? "")) {
            ForEach(cases, id: \.self) {
                mapping($0).tag($0)
            }
        }
    }
}

extension EnumPicker {
    init(_ selected: Binding<T>, title: String? = nil, mapping: @escaping (T) -> V) {
        self.init(selected: selected, mapping: mapping)
    }
}

extension EnumPicker where T: RawRepresentable, T.RawValue == String, V == Text {
    init(_ selected: Binding<T>, title: String? = nil, cases: [T] = Array(T.allCases)) {
        self.init(selected: selected, cases: cases, title: title) {
            Text($0.rawValue)
        }
    }
}

extension EnumPicker where T: UIDescribing, V == Text {
    init(_ selected: Binding<T>, title: String? = nil, cases: [T] = Array(T.allCases)) {
        self.init(selected: selected, cases: cases, title: title) {
            Text($0.uiDescription)
        }
    }
}
