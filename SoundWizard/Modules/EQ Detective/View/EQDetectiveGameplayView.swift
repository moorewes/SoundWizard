//
//  EQDetectiveGameplayView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/9/20.
//

import SwiftUI

struct EQDetectiveGameplayView: View {
    
    @ObservedObject var game: EQDetectiveGame
    
    var body: some View {
        
            ZStack {
                Color.darkBackground
                    .ignoresSafeArea()
                
                VStack() {
                    
                    StatusBar(game: game)
                        .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30))
                        .opacity(game.practicing ? 0 : 1)
                        
                    gameInfoView
                        .padding()
                    
                    FrequencySlider(data: game, frequency: $game.selectedFreq)
                        .padding(EdgeInsets(top: 10, leading: 40, bottom: 10, trailing: 40))
                        .onTapGesture(count: 2) {
                            game.toggleFilterOnState()
                        }
                        
                    togglePicker
                        .frame(width: 200, height: nil)
                        .padding(.bottom, 40)
                    
                    ZStack {
                        RoundedRectButton(title: submitButtonText, action: { game.submitGuess() })
                            .opacity(game.showSubmitButton ? 1 : 0)
                        RoundedRectButton(title: continueButtonText, action: { game.continueToNextTurn() })
                            .opacity(game.showContinueButton ? 1 : 0)
                    }
                    .padding(.bottom, 60)
                    
                    
                }
                .onAppear {
                    game.start()
                }
                .onDisappear() {
                    game.stopAudio()
                }
                
            }
    }
    
    private var gameInfoView: some View {
        
        ZStack {
            resultsView
                .opacity(game.inBetweenTurns ? 1 : 0)
            
            Text(instructionText)
                .font(.mono(.title3))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .opacity(game.inBetweenTurns ? 0 : 0.8)
            
        }
    }
    
    var resultsView: some View {
        VStack {
            Text(solutionText)
                .font(.mono(.callout))
                .foregroundColor(.init(white: 1, opacity: 0.5))
            Text(game.solutionText)
                .font(.mono(.largeTitle))
                .foregroundColor(.teal)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
        
            Text(game.practicing ? "swipe to change filter" : game.feedbackText)
                .fixedSize()
                .font(.mono(.subheadline))
                .foregroundColor(game.practicing ? Color.darkGray : feedbackColor)
        }
    }
    

    
    private var togglePicker: some View {
        Picker("", selection: $game.filterOnState) {
            Text(firstPickerItemText).tag(0)
            Text(secondPickerItemText).tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
    // MARK: - Constants
    
    private let instructionText = "Choose the \ncenter frequency"
    private let pickerName = "EQ Bypass"
    private let firstPickerItemText = "EQ Off"
    private let secondPickerItemText = "EQ On"
    private let solutionText = "Answer"
    private let submitButtonText = "Submit"
    private let continueButtonText = "Continue"
    
    private var feedbackColor: Color {
        guard let success = game.currentTurn?.score?.successLevel else { return Color.clear }
        return .successLevelColor(success)
    }
    
}

struct GameplayView_Previews: PreviewProvider {
    
    static let level = TestData.eqdLevel
    static let game = EQDetectiveGame(level: level, completionHandler: TestData.GameHandler().completionHandler)
    
    static var previews: some View {
        EQDetectiveGameplayView(game: game)
            .previewDevice("iPhone 12 Pro")
    }
}
