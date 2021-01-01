//
//  EQMatchLevelBrowser.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/30/20.
//

import SwiftUI

struct EQMatchLevelBrowser: View {
    @ObservedObject var store: EQMatchLevelStore
    let openLevel: (Level) -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack() {
                Filters(store: store)
                    .padding(.vertical, 25)
                
                ForEach(BandFocus.allCases) { focus in
                    let levels = store.filteredLevels(with: focus)
                    if levels.isNotEmpty {
                        LevelListHeader(title: focus.uiDescription, stars: levels.stars)
                        
                        LevelPicker(levels: levels) { level in
                            openLevel(level)
                        }
                        .padding(.bottom, 50)
                    }
                }
                    
                
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .navigationBarTitle("EQ Match", displayMode: .inline)
        //.navigationBarItems(trailing: addLevelButton)
    }
    
    
}

extension EQMatchLevelBrowser {
    struct Filters: View {
        @ObservedObject var store: EQMatchLevelStore
        
        var body: some View {
            VStack() {
                // Difficulty may be useless for this game?
//                EnumPicker($store.difficultySelection)
//                    .padding(pickerPadding)
//
                EnumPicker($store.bandCountSelection)
                    .padding(pickerPadding)
                
                EnumPicker($store.modeSelection)
                    .padding(pickerPadding)
                
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        
        private let pickerPadding = EdgeInsets(top: 5, leading: 15, bottom: 5, trailing: 15)
    }
}

struct EQMatchLevelBrowser_Previews: PreviewProvider {
    static var previews: some View {
        Appearance.setup()
        return NavigationView { EQMatchLevelBrowser(store: EQMatchLevelStore(levels: [TestData.eqMatchLevel])) {_ in} }
    }
}

enum BandCount: Int, CaseIterable, UIDescribing {
    case single = 1, dual, triple
    
    var uiDescription: String {
        switch self {
        case .single: return "Single Band"
        case .dual: return "Dual Band"
        case .triple: return "Triple Band"
        }
    }
}



struct EnumPicker<T: Hashable & CaseIterable, V: View>: View {
    @Binding var selected: T
    var title: String? = nil
    let mapping: (T) -> V
    
    var body: some View {
        Picker(selection: $selected, label: Text(title ?? "")) {
            ForEach(Array(T.allCases), id: \.self) {
                mapping($0).tag($0)
            }
        }
    }
}

extension EnumPicker where T: RawRepresentable, T.RawValue == String, V == Text {
    init(_ selected: Binding<T>, title: String? = nil) {
        self.init(selected: selected, title: title) {
            Text($0.rawValue)
        }
    }
}

extension EnumPicker where T: UIDescribing, V == Text {
    init(_ selected: Binding<T>, title: String? = nil) {
        self.init(selected: selected, title: title) {
            Text($0.uiDescription)
        }
    }
}
