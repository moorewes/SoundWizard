//
//  LevelsView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/13/20.
//

import SwiftUI

struct LevelsView: View {
    
    @ObservedObject var manager: LevelsViewModel
    @State var difficultySelection: Int = 1
    @State var gainTypeSelection: Int = 1
        
    init(game: Game) {
        manager = LevelsViewModel(game: game)
        setupPicker()
    }
    
    var body: some View {

        ScrollView(.vertical) {
            
            VStack() {
                
                Picker(selection: $difficultySelection, label: Text("Picker")) {
                    ForEach(LevelDifficulty.allCases) { difficulty in
                        Text(difficulty.uiDescription)
                            .tag(difficulty.rawValue)
                            .font(.stdSemiBold(14))

                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.horizontal)
                .padding(.vertical, 30)
                
                if showGainTypePicker {
                    Picker(selection: $gainTypeSelection, label: Text("Picker")) {
                        Text("Boost")
                            .tag(1)
                            .font(.stdSemiBold(14))
                        Text("Cut")
                            .tag(2)
                            .font(.stdSemiBold(14))
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 80)
                    .padding(.bottom, 30)
                }
                                                    
                ForEach(BandFocus.allCases) { focus in
                    let gainType = showGainTypePicker ? gainTypeSelection : 1
                    let levels = manager.levels(focus: focus,
                                                difficulty: selectedDifficulty,
                                                gainType: gainType)
                    
                    sectionHeader(focus: focus, levels: levels)
                        .padding(.bottom, 10)
                        .padding(.leading)
                    
                    levelsList(levels: levels)
                        .padding(.bottom, 50)
                }
            }
            
            
            
        }
        .navigationBarTitle(manager.game.name, displayMode: .inline)
        .background(Color.darkBackground.ignoresSafeArea())
        .fullScreenCover(isPresented: $manager.showLevel, onDismiss: {
            manager.dismissLevel()
        }, content: {
            gameShellView(for: manager.selectedLevel!)

        })
        
    }
    
    private func sectionHeader(focus: BandFocus, levels: [EQDetectiveLevel]) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(focus.uiDescription)
                .font(.stdSemiBold(16))
                .foregroundColor(.white)
            
            Star(filled: true, animated: false)
                .font(.system(size: 14))
                .padding(.leading, 10)
            
            Text(manager.starProgress(levels: levels))
                .font(.monoSemiBold(14))
                .foregroundColor(.lightGray)
            
            Spacer()
        }
    }
    
    private func levelsList(levels: [EQDetectiveLevel]) -> some View {
        return ScrollView(.horizontal)  {
            HStack {
                ForEach(levels) { level in
                    Button(action: {
                        manager.selectLevel(level)
                    }, label: {
                        LevelCellView(level: level)
                    })
                    .frame(width: 80, height: 80, alignment: .center)
                    .cornerRadius(15)
                    .padding(.leading)
                    .padding(.trailing, -5)
                }
            }
        }
    }
    
    private func gameShellView(for level: Level) -> some View {
        return GameShellView(isPresented: $manager.showLevel, level: level)
    }
    
    private func setupPicker() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.darkGray)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.white)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var showGainTypePicker: Bool {
        difficultySelection != 1
    }
    
    var selectedDifficulty: LevelDifficulty {
        LevelDifficulty(rawValue: difficultySelection)!
    }
    
}

struct LevelsView_Previews: PreviewProvider {
    static var previews: some View {
        LevelsView(game: .eqDetective)
            .preferredColorScheme(.dark)
    }
}
