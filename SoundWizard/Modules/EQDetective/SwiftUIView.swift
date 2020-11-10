//
//  SwiftUIView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/9/20.
//

import SwiftUI

struct GameplayView: View {
    
    @ObservedObject var manager = EQDetectiveGameplayManager()
    
    var body: some View {
        ZStack {
            Color(white: 0.2, opacity: 1)
                .ignoresSafeArea()
            
            VStack() {
                GameplayNavBarView()
                    .padding(EdgeInsets(top: 5, leading: 40, bottom: 0, trailing: 60))
                
                StatusBar(manager: manager)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 20, trailing: 10))
                
                ResultsView()
                    .padding()//25)
                
                FrequencyGraph(manager: manager)
                    .padding()
                
                Button(action: {
                    
                }, label: {
                    ZStack {
                        Rectangle()
                            .foregroundColor(.teal)
                            .cornerRadius(10)
                            .frame(width: 200, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                        Text("Guess")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Color(white: 0.2, opacity: 1))
                    }
                    
                })
                
                FilterTogglePicker()
                    .frame(width: 200, height: 80)
                    .padding()
                
            }
        }
    }
}

struct FilterTogglePicker: View {
    @State var on = 0
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = .systemTeal
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.black.withAlphaComponent(0.8)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
    }
    
    var body: some View {
        Picker(selection: $on, label: Text("EQ Bypass")) {
            Text("EQ Off").tag(0)
                .foregroundColor(Color(white: 0.2, opacity: 1))
            Text("EQ On").tag(1)
        }
        .pickerStyle(SegmentedPickerStyle())
    }
}

struct EQGraphView: UIViewRepresentable {
    
    @ObservedObject var manager: EQDetectiveGameplayManager
    
    func makeUIView(context: Context) -> FrequencyGraphView {
        let view = FrequencyGraphView()
        view.backgroundColor = UIColor.clear
        view.graphLineColor = UIColor.systemTeal.withAlphaComponent(0.6)
        return view
    }
    
    func updateUIView(_ uiView: FrequencyGraphView, context: Context) {
        uiView.updateCurrentFreq(movement: manager.graphDragOffset)
    }
}

struct FrequencyGraph: View {
    
    @ObservedObject var manager: EQDetectiveGameplayManager
    
    @State var lastTranslation: CGFloat = 0.0
    
    var body: some View {
        EQGraphView(manager: manager)
            .gesture(
                DragGesture(minimumDistance: 1)
                    .onChanged { (value) in
                        manager.graphDragOffset = value.translation.width - lastTranslation
                        lastTranslation = value.translation.width
                    }
                    .onEnded { _ in
                        lastTranslation = 0
                    }
            )
    }
}

struct ResultsView: View {
    var body: some View {
        VStack {
            Text("Answer")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.init(white: 1, opacity: 0.5))
            Text("500 Hz")
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.teal)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            Text("Off by")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.init(white: 1, opacity: 0.5))
            Text("1 Octave")
                .font(.system(size: 22, weight: .heavy))
                .foregroundColor(.teal)
            
        }
    }
}

struct StatusBar: View {
    
    @ObservedObject var manager: EQDetectiveGameplayManager
    
    var body: some View {
        HStack {
            // Score
            
            VStack {
                Text("SCORE")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.init(white: 1, opacity: 0.5))
                Text("\(Int(manager.engine.currentRound?.score ?? 0))")
                    .font(.system(size: 22, weight: .heavy))
                    .foregroundColor(.teal)
            }
            .fixedSize()
            .frame(width: 80, height: 50, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
            
            
            
            VStack {
                Text("Turn \(manager.turnNumber) of 10")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.init(white: 1, opacity: 0.5))
                ProgressView(value: 0.5)
                    .accentColor(.teal)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 10, trailing: 10))
                    
            }
            .padding()
            
            
            
            Button(action: {
                
            }, label: {
                Image(systemName: "speaker.fill")
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
                .foregroundColor(.teal)
            
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
}

struct BackButton: View {
    
    var body: some View {
        VStack {
            Button(action: {
                withAnimation {
                    
                }
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.system(size: 20, weight: .bold))
            })
            
        }
    }
}

struct GameplayView_Previews: PreviewProvider {
    static var previews: some View {
        GameplayView()
    }
}
