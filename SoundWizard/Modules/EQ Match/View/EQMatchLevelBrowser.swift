//
//  EQMatchLevelBrowser.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/30/20.
//

import SwiftUI

struct EQMatchLevelBrowser: View {
    @ObservedObject var store: EQMatchLevelStore
    @State var format = EQMatchLevel.Format.defaultFormat
    let launch: (Level) -> Void
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                FilterView(format: $format)
                    .padding(.vertical, 25)
                
                LevelCollection(levels: filteredLevels(),
                             launch: launch)
            }
        }
        .navigationBarTitle("EQ Match", displayMode: .inline)
    }
    
    private func filteredLevels() -> [EQMatchLevel] {
        store.filteredLevels(format: format)
    }
}

extension EQMatchLevelBrowser {
    struct LevelCollection: View {
        let levels: [EQMatchLevel]
        let launch: (Level) -> Void
        
        var body: some View {
            VStack {
                ForEach(LevelDifficulty.allCases) { difficulty in
                    let levels = self.levels.filter { $0.difficulty == difficulty }
                    if levels.isNotEmpty {
                        LevelListHeader(title: difficulty.uiDescription, stars: levels.stars)
                        
                        LevelPicker(levels: levels) { level in
                            launch(level)
                        }
                        .padding(.bottom, 50)
                    }
                }
            }
        }
    }
}

extension EQMatchLevelBrowser {
    struct FilterView: View {
        @Binding var format: EQMatchLevel.Format
        
        var body: some View {
            VStack {
                HStack {
                    PickerRow(title: "Range", items: BandFocus.allCases, selectedItem: $format.bandFocus)
                    Image(systemName: "chevron.right")
                        .font(.std(.footnote))
                        .foregroundColor(.darkGray)
                }
                .padding()
                
                DetailRow(title: "Filters") {
                    EnumPicker($format.bandCount) { count in
                        Text(String(count.rawValue))
                    }
                }
                
                DetailRow(title: "Mode") {
                    EnumPicker($format.mode)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
        }
    }
}

private extension EQMatchLevel.Format {
    static var defaultFormat: EQMatchLevel.Format {
        EQMatchLevel.Format(mode: .fixedFrequency, bandCount: .single, bandFocus: .all)
    }
}

struct EQMatchLevelBrowser_Previews: PreviewProvider {
    static var previews: some View {
        Appearance.setup()
        let store = EQMatchLevelStore(levels: [TestData.eqMatchLevel])
        return NavigationView { EQMatchLevelBrowser(store: store) {_ in} }
    }
}
