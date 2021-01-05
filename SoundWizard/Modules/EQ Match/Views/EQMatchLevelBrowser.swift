//
//  EQMatchLevelBrowser.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/30/20.
//

import SwiftUI

struct EQMatchLevelBrowser: View {
    @ObservedObject var store: EQMatchLevelStore
    @State var filter = Filter()
    let launchAction: (Level) -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack() {
                FilterPickers(filter: $filter)
                    .padding(.vertical, 25)
                
                ForEach(BandFocus.allCases) { focus in
                    let levels = store.filteredLevels(with: focus)
                    if levels.isNotEmpty {
                        LevelListHeader(title: focus.uiDescription, stars: levels.stars)
                        
                        LevelPicker(levels: levels) { level in
                            launchAction(level)
                        }
                        .padding(.bottom, 50)
                    }
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
        .navigationBarTitle("EQ Match", displayMode: .inline)
    }
}

extension EQMatchLevelBrowser {
    init(levels: [EQMatchLevel], launchAction: @escaping (Level) -> Void) {
        self.store = EQMatchLevelStore(levels: levels)
        self.launchAction = launchAction
    }
}

extension EQMatchLevelBrowser {
    struct Filter {
        var difficulty: LevelDifficulty = .easy
        var mode: EQMatchLevel.Mode = .free
        var bandCount: BandCount = .single
    }
    
    struct FilterPickers: View {
        @Binding var filter: Filter
        
        var body: some View {
            VStack() {
                EnumPicker($filter.difficulty)
                    .padding(pickerPadding)

                EnumPicker($filter.bandCount)
                    .padding(pickerPadding)
                
                EnumPicker($filter.mode)
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
        return NavigationView { EQMatchLevelBrowser(levels: [TestData.eqMatchLevel]) {_ in} }
    }
}
