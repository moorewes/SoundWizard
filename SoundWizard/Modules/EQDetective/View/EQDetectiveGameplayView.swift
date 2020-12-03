//
//  EQDetectiveGameplayView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/9/20.
//

import SwiftUI

struct EQDetectiveGameplayView: View {
    
    @ObservedObject var game: EQDetectiveGame
    
    init(level: EQDetectiveLevel, gameViewState: Binding<GameViewState>) {
        game = EQDetectiveGame(level: level, viewState: gameViewState)
        setupPicker()
    }
    
    var body: some View {
        
            ZStack {
                Color.darkBackground
                    .ignoresSafeArea()
                
                VStack() {
                    
                    StatusBar(game: game)
                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                        
                    gameInfoView
                        .padding()
                    
                    FrequencySlider(data: game, frequency: $game.selectedFreq)
                        .padding(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                        
                    
                    submitGuessButton
                        .opacity(game.showGuessButton ? 1 : 0)
                    
                    togglePicker
                        .frame(width: 200, height: 80)
                        .padding()
                    
                }
                .onAppear {
                    game.start()
                }
                
            }
    }
    
    private var gameInfoView: some View {
        
        ZStack {
            resultsView
                .opacity(game.showResultsView ? 1 : 0)
            
            Text(instructionText)
                .font(.monoSemiBold(22))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .opacity(game.showResultsView ? 0 : 0.8)
            
        }
    }
    
    var resultsView: some View {
        VStack {
            Text(solutionText)
                .font(.monoBold(16))
                .foregroundColor(.init(white: 1, opacity: 0.5))
            Text(game.solutionText)
                .font(.monoBold(32))
                .foregroundColor(.teal)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
        
            Text(game.feedbackText)
                .fixedSize()
                .font(.monoBold(14))
                .foregroundColor(feedbackColor)
        }
    }
    
    private var submitGuessButton: some View {
        Button(action: {
            game.submitGuess()
        }, label: {
            ZStack {
                Rectangle()
                    .foregroundColor(.teal)
                    .cornerRadius(10)
                    .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text(submitText)
                    .font(.monoBold(20))
                    .foregroundColor(.darkBackground)
            }
            
        })
    }
    
    private var togglePicker: some View {
        Picker(selection: $game.filterOnState, label: Text(pickerName)) {
            Text(firstPickerItemText).tag(0)
                .foregroundColor(.darkBackground)
                .font(.monoBold(18))
            Text(secondPickerItemText).tag(1)
                .font(.monoBold(18))
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    private func setupPicker() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemTeal
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black.withAlphaComponent(0.8)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.monoMedium(14)], for: .normal)
    }
    
    // MARK: - Constants
    
    private let instructionText = "Choose the \ncenter frequency"
    private let pickerName = "EQ Bypass"
    private let firstPickerItemText = "EQ Off"
    private let secondPickerItemText = "EQ On"
    private let solutionText = "Answer"
    private let submitText = "Submit"
    
    private var feedbackColor: Color {
        guard let success = game.currentTurn?.score?.successLevel else { return Color.clear }
        return .successLevelColor(success)
    }
    
}

struct GameplayView_Previews: PreviewProvider {
    static var previews: some View {
        EQDetectiveGameplayView(level: EQDetectiveLevel.level(0)!, gameViewState: .constant(.inGame))
            .previewDevice("iPhone 12 Pro")
    }
}
