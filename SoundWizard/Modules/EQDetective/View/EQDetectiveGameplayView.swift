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
    }
    
    var body: some View {
        
            ZStack {
                Color.darkBackground
                    .ignoresSafeArea()
                
                VStack() {
                    
                    StatusBar(game: game)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        
                    gameInfoView
                        .padding()
                    
                    FrequencySlider(game: game)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    
                    submitGuessButton
                        .opacity(game.showGuessButton ? 1 : 0)
                    
                    TogglePicker(game: game)
                        .frame(width: 200, height: 80)
                        .padding()
                    
                }
                .onAppear(perform: {
                    game.start()
                })
                
            }
    }
    
    var gameInfoView: some View {
        
        ZStack {
            ResultsView(game: game)
                .opacity(game.showResultsView ? 1 : 0)
            
            Text(instructionText)
                .font(.monoSemiBold(22))
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .opacity(game.showResultsView ? 0 : 0.8)
            
        }
    }
    
    var submitGuessButton: some View {
        Button(action: {
            game.submitGuess()
        }, label: {
            ZStack {
                Rectangle()
                    .foregroundColor(.teal)
                    .cornerRadius(10)
                    .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                Text("Submit")
                    .font(.monoBold(20))
                    .foregroundColor(.darkBackground)
            }
            
        })
    }
    
    var instructionText = "Choose the \ncenter frequency"
    
}

struct TogglePicker: View {
    @ObservedObject var game: EQDetectiveGame
    
    private let pickerName = "EQ Bypass"
    private let firstItemText = "EQ Off"
    private let secondItemText = "EQ On"
    
    init(game: EQDetectiveGame) {
        self.game = game
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemTeal
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black.withAlphaComponent(0.8)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.font: UIFont.monoMedium(14)], for: .normal)
    }
    
    var body: some View {
        Picker(selection: $game.filterOnState, label: Text(pickerName)) {
            Text(firstItemText).tag(0)
                .foregroundColor(.darkBackground)
                .font(.monoBold(18))
            Text(secondItemText).tag(1)
                .font(.monoBold(18))
        }
        .pickerStyle(SegmentedPickerStyle())
    }
    
}

struct ResultsView: View {
    
    @ObservedObject var game: EQDetectiveGame

    var body: some View {
        VStack {
            Text("Answer")
                .font(.monoBold(16))
                .foregroundColor(.init(white: 1, opacity: 0.5))
            Text(game.solutionText)
                .font(.monoBold(32))
                .foregroundColor(.teal)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
//            Text("Off by")
//                .font(.monoBold(12))
//                .foregroundColor(.init(white: 1, opacity: 0.5))
//            Text(manager.octaveErrorString)
//                .font(.monoBold(18))
//                .foregroundColor(.teal)
        
            Text(game.feedbackText)
                .fixedSize()
                .font(.monoBold(14))
                .foregroundColor(feedbackColor)
            
        }
    }
    
    var feedbackColor: Color {
        guard let success = game.currentTurn?.score?.successLevel else { return Color.clear }
        return .successLevelColor(success)
    }
    
}

struct StatusBar: View {
    
    @ObservedObject var game: EQDetectiveGame
    
    var body: some View {
        HStack {
            // Score
            
            VStack {
                Text("SCORE")
                    .font(.monoBold(16))
                    .foregroundColor(.init(white: 1, opacity: 0.5))
                MovingCounter(number: game.score)
                    .animation(.linear(duration: 0.5))
            }
            .frame(width: 80, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            
            
            VStack {
                Text("\(game.currentTurn?.number ?? 1) of 10")
                    .font(.monoBold(16))
                    .foregroundColor(.init(white: 1, opacity: 0.5))
                ProgressView(value: game.completion)
                    .accentColor(.teal)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                    
            }
            .padding()
            
            
            
            Button(action: {
                game.toggleMute()
            }, label: {
                Image(systemName: muteButtonImageName)
                    .foregroundColor(.teal)
                    .scaleEffect(1.3)
                
            })
            .frame(width: 80, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        
    }
    
    var muteButtonImageName: String {
        game.muted ? "speaker" : "speaker.fill"
    }
    
}

struct GameplayNavBarView: View {
    
    @State var levelNumber: Int
    
    var body: some View {
        HStack {
            BackButton()
                .foregroundColor(.white)
                .opacity(0.6)
            
            Spacer()
            
            Text("Level \(levelNumber)")
                .foregroundColor(.teal)
                .font(.monoSemiBold(20))
            
            Spacer()
        }
    }
    
    
}

extension Color {
    static let teal = Color(UIColor.systemTeal)
    static let darkBackground = Color(white: 0.2, opacity: 1)
    static let extraDarkGray = Color(white: 0.08)
    
    static func successLevelColor(_ successLevel: ScoreSuccessLevel) -> Color {
        switch successLevel {
        case .failed, .justMissed:
            return Color.red
        case .fair:
            return Color.yellow
        case .great, .perfect:
            return Color.green
        }
    }
    
}

struct BackButton: View {
    
    @Environment(\.presentationMode) var presentation
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    presentation.wrappedValue.dismiss()
                    
                }
            }, label: {
                Text("Quit")
                    .font(.monoBold(18))
            })
            
        }
    }
}

struct GameplayView_Previews: PreviewProvider {
    static var previews: some View {
        EQDetectiveGameplayView(level: EQDetectiveLevel.level(0)!, gameViewState: .constant(.inGame))
            .previewDevice("iPhone 12 Pro")
    }
}
