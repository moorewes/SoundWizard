//
//  LevelsView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/13/20.
//

import SwiftUI
import CoreData

struct EQDetectiveLevelsView: View {
    
    @EnvironmentObject var stateController: StateController
    @State var difficultySelection: Int = 1
    @State var gainTypeSelection: Int = 1
    @State var presentingLevel = false
    
    var levels: [EQDetectiveLevel]
    
    var body: some View {

        ScrollView(.vertical) {
            
            VStack() {
                
                Picker(selection: $difficultySelection, label: Text("Picker")) {
                    ForEach(LevelDifficulty.allCases) { difficulty in
                        Text(difficulty.uiDescription)
                            .tag(difficulty.rawValue)
                            .font(.std(.subheadline))

                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.vertical, 30)
                
                if showGainTypePicker {
                    Picker(selection: $gainTypeSelection, label: Text("Picker")) {
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
                    .transition(.slide)
                }
                
                ForEach(BandFocus.allCases) { focus in
                    let gainType = showGainTypePicker ? gainTypeSelection : 1
                    let levels = self.levels(focus: focus,
                                                difficulty: selectedDifficulty,
                                                gainType: gainType)
                    
                    sectionHeader(focus: focus, levels: levels)
                        .padding(.bottom, 10)
                        .padding(.leading)
                    
                    LevelsHorizontalList(levels: levels) {
                        stateController.level = $0 as! EQDetectiveLevel
                    }
                        .padding(.bottom, 50)
                }
            }
        }
        .navigationBarTitle(Game.eqDetective.name, displayMode: .inline)
        .background(Color.darkBackground.ignoresSafeArea())
        .fullScreenCover(isPresented: $stateController.presentingLevel) {
            gameShellView(for: stateController.level! as! EQDetectiveLevel)
        }
    }
    
    private func sectionHeader(focus: BandFocus, levels: [EQDetectiveLevel]) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(focus.uiDescription)
                .font(.std(.callout))
                .foregroundColor(.white)
            
            Star(filled: true, animated: false)
                .font(.system(size: 14))
                .padding(.leading, 10)
            
            Text(stateController.starProgress(for: levels).formatted)
                .font(.mono(.subheadline))
                .foregroundColor(.lightGray)
            
            Spacer()
        }
    }
    
    private func gameShellView(for level: EQDetectiveLevel) -> some View {
        return GameShellView(level: level)
    }
    
    private func levels(focus: BandFocus, difficulty: LevelDifficulty, gainType: Int) -> [EQDetectiveLevel] {
        levels.filter {
            $0.bandFocus == focus &&
            $0.difficulty == difficulty &&
            (gainType == 1) == ($0.filterGainDB > 0)
        }
    }
    
    var showGainTypePicker: Bool {
        difficultySelection != 1
    }
    
    var selectedDifficulty: LevelDifficulty {
        LevelDifficulty(rawValue: difficultySelection)!
    }
    
}
//
//struct LevelsView_Previews: PreviewProvider {
//    static var previews: some View {
//        EQDetectiveLevelsView(game: .eqDetective)
//            .preferredColorScheme(.dark)
//    }
//}
