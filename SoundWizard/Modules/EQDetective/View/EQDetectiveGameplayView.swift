//
//  EQDetectiveGameplayView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/9/20.
//

import SwiftUI

struct EQDetectiveGameplayView: View {
    
    @ObservedObject var manager = EQDetectiveViewModel()
    
    init(level: Level) {
        manager.level = level
    }
    
    var body: some View {
            ZStack {
                Color.darkBackground
                    .ignoresSafeArea()
                    .navigationBarTitle("Level \(manager.level.levelNumber)",
                                        displayMode: .inline)
                
                VStack() {
                    GameplayNavBarView()
                        .padding(EdgeInsets(top: 5, leading: 30, bottom: 0, trailing: 70))
                    
                    StatusBar(manager: manager)
                        .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                        
                    ZStack {
                        ResultsView(manager: manager)
                            .padding()
                            //.hidden(manager.state == .notStarted)
                            .opacity(manager.showResultsView ? 1 : 0)
                        
                        if manager.state == .awaitingGuess {
                            Text("Choose the \ncenter frequency")
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        
                    }
                    
                    
                    FrequencyPickerView(percentage: $manager.freqSliderPercentage,
                                        octavesShaded: $manager.octaveErrorRange,
                                        octaveCount: $manager.octaveCount,
                                        answerOctave: manager.answerOctave,
                                        answerLineColor: manager.successColor)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    
                    Button(action: {
                        manager.didTapProceedButton()
                    }, label: {
                        ZStack {
                            Rectangle()
                                .foregroundColor(.teal)
                                .cornerRadius(10)
                                .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            Text(manager.proceedButtonLabelText)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.darkBackground)
                        }
                        
                    })
                    
                    TogglePicker(manager: manager,
                                 firstItemText: "EQ Off",
                                 secondItemText: "EQ ON")
                        .frame(width: 200, height: 80)
                        .padding()
                    
                }
                .onAppear(perform: {
                    manager.viewDidAppear()
                })
                
            }
    }
}

struct TogglePicker: View {
    @ObservedObject var manager: EQDetectiveViewModel
    
    let firstItemText: String
    let secondItemText: String
    
    init(manager: EQDetectiveViewModel, firstItemText: String, secondItemText: String) {
        self.manager = manager
        self.firstItemText = firstItemText
        self.secondItemText = secondItemText
        
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemTeal
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black.withAlphaComponent(0.8)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var body: some View {
        Picker(selection: $manager.filterOnState, label: Text("EQ Bypass")) {
            Text(firstItemText).tag(0)
                .foregroundColor(.darkBackground)
            Text(secondItemText).tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct ResultsView: View {
    @ObservedObject var manager: EQDetectiveViewModel

    var body: some View {
        VStack {
            Text("Answer")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.init(white: 1, opacity: 0.5))
            Text(manager.answerFreqString)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.teal)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            Text("Off by")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.init(white: 1, opacity: 0.5))
            Text(manager.octaveErrorString)
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(.teal)
        
            Text(manager.feedbackLabelText)
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(manager.successColor)
                .offset(x: 0, y: 10)
            
        }
    }
}

struct StatusBar: View {
    
    @ObservedObject var manager: EQDetectiveViewModel
    @State var highlighted = true
    
    var progress: Double { Double(manager.turnNumber) / 10.0 }
    
    var body: some View {
        HStack {
            // Score
            
            VStack {
                Text("SCORE")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.init(white: 1, opacity: 0.5))
                Text("\(Int(manager.score))")
                    .font(.system(size: 22, weight: .heavy))
                    .foregroundColor(.teal)
            }
            //.fixedSize()
            .frame(width: 80, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            
            
            VStack {
                Text("Turn \(manager.turnNumber) of 10")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.init(white: 1, opacity: 0.5))
                ProgressView(value: progress)
                    .accentColor(.teal)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                    
            }
            .padding()
            
            
            
            Button(action: {
                manager.audioShouldPlay.toggle()
                highlighted.toggle()
            }, label: {
                Image(systemName: highlighted ? "speaker.fill" : "speaker")
                    .foregroundColor(.teal)
                    .scaleEffect(1.3)
                    //.padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                
            })
            .frame(width: 80, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
        }
        
    }
}

struct GameplayNavBarView: View {
    var body: some View {
        HStack {
            BackButton()
                .foregroundColor(.white)
                .opacity(0.6)
            
            Spacer()
            
            Text("Level 1")
                .foregroundColor(.teal)
                .font(.system(size: 20, weight: .semibold))
            
            Spacer()
        }
    }
    
    
}

extension Color {
    static let teal = Color(UIColor.systemTeal)
    static let darkBackground = Color(white: 0.2, opacity: 1)
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
                    .font(.system(size: 18, weight: .bold))
            })
            
        }
    }
}

struct GameplayView_Previews: PreviewProvider {
    static var previews: some View {
        EQDetectiveGameplayView(level: EQDetectiveLevel.level(0)!)
            .previewDevice("iPhone 12 Pro")
    }
}
