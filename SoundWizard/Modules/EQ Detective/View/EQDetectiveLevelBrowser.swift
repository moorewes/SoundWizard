//
//  EQDetectiveLevelBrowser.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/13/20.
//

import SwiftUI
import CoreData

struct DifficultyPicker: View {
    @Binding var selection: Int
    
    var body: some View {
        Picker(selection: $selection, label: Text("Picker")) {
            ForEach(LevelDifficulty.allCases) { difficulty in
                Text(difficulty.uiDescription)
                    .tag(difficulty.rawValue)
                    .font(.std(.subheadline))
            }
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal)
        .padding(.vertical, 30)
    }
}

struct CutBoostPicker: View {
    @Binding var selection: Int
    
    var body: some View {
        Picker(selection: $selection, label: Text("Picker")) {
            Text("Boost")
                .tag(1)
                .font(.std(.subheadline))
            Text("Cut")
                .tag(2)
                .font(.std(.subheadline))
        }
        .pickerStyle(SegmentedPickerStyle())
        .padding(.horizontal, 80)
        .padding(.bottom, 30)
    }
}



struct EQDetectiveLevelBrowser: View {
    
    var levels: [EQDLevel]
    var openLevel: (Level) -> Void
    
    init(levels: [EQDLevel], selectionHandler: @escaping (Level) -> Void) {
        self.levels = levels
        self.openLevel = selectionHandler
    }
    
    @State private var difficultySelection: Int = 1
    @State private var gainTypeSelection: Int = 1

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack() {
                DifficultyPicker(selection: $difficultySelection)
                
                if showGainTypePicker {
                    CutBoostPicker(selection: $gainTypeSelection)
                }
                ForEach(BandFocus.allCases) { focus in
                    let levels = filteredLevels(focus: focus)
                    if levels.isNotEmpty {
                        LevelListHeader(title: focus.uiDescription, stars: levels.stars)
                        
                        LevelPicker(levels: levels) { level in
                            openLevel(level)
                        }
                        .padding(.bottom, 50)
                    }
                }
            }
        }
        .navigationBarTitle(Game.eqDetective.name, displayMode: .inline)
        .navigationBarItems(trailing: addLevelButton)
    }
    
    // TODO: Refactor to use a class to manage filtering levels
    private func filteredLevels(focus: BandFocus) -> [EQDLevel] {
        levels.filter { level in
            level.bandFocus == focus &&
                level.difficulty == selectedDifficulty &&
                level.filterBoosts == selectedFilterBoost
        }
    }
    
    var showGainTypePicker: Bool {
        difficultySelection != 1
    }
    
    var selectedFilterBoost: Bool {
        let gainType = showGainTypePicker ? gainTypeSelection : 1
        return gainType == 1
    }
    
    var selectedDifficulty: LevelDifficulty {
        LevelDifficulty(rawValue: difficultySelection)!
    }
    
    var addLevelButton: some View {
        NavigationLink(
            destination: EQDCustomLevelBrowser(levels: []),
            label: {
                Text("+")
                    .font(.std(.title2))
                    .foregroundColor(.teal)
                    .padding(.trailing, 10)
            })
    }
    
}

struct EQDetectiveLevelBrowser_Previews: PreviewProvider {
    static var previews: some View {
        EQDetectiveLevelBrowser(levels: [TestData.eqdLevel], selectionHandler: {_ in})
            .primaryBackground()
    }
}
