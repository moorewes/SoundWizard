//
//  EQDetectiveGameplayView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/9/20.
//

import SwiftUI

struct EQDetectiveGameplayView: View {
    
    @ObservedObject var manager = EQDetectiveViewModel()
    
    var body: some View {
        ZStack {
            Color(white: 0.2, opacity: 1)
                .ignoresSafeArea()
            
            VStack() {
                GameplayNavBarView()
                    .padding(EdgeInsets(top: 5, leading: 40, bottom: 0, trailing: 60))
                
                StatusBar(manager: manager)
                    .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                
                ResultsView()
                    .padding()//25)
                
                EQGraph(percentage: $manager.freqSliderPercentage, octaveRange: manager.octaveRange)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                
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

struct EQGraph: View {
    
    @Binding var percentage: CGFloat
    @State var lastTranslation: CGFloat = 0.0
    
    var freq: Float {
        let octave = Float(percentage) * 10
        return AudioCalculator.freq(fromOctave: octave)
    }
    
    let octaveRange: Float
    
    var graphLineFreqs: [Float] = [31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    var graphLineOctaves: [Float] {
        graphLineFreqs.map { AudioCalculator.octave(fromFreq: $0) }
    }
    var topSpace: CGFloat = 30
    var bottomSpace: CGFloat = 30
    var labelWidth: CGFloat = 100
        
    var body: some View {
        GeometryReader { geometry in

            // Graph Lines
            Path { path in
                let frame = geometry.frame(in: .local)
                for x in lineXPositions(width: frame.width) {
                    path.move(to: CGPoint(x: x, y: topSpace))
                    path.addLine(to: CGPoint(x: x, y: frame.maxY - bottomSpace))
                }
            }
                .stroke(Color.teal.opacity(0.5))
            
            // Graph Line Labels
            ForEach(graphLineFreqs, id: \.self) { freq in
                let leftX = percentage * geometry.size.width - labelWidth / 2
                Text("\(freqIntString(freq))")
                    .frame(width: labelWidth, height: 20, alignment: .center)
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(Color(white: 0.6, opacity: 1))
                    .offset(x: leftX, y: geometry.frame(in: .local).height - bottomSpace)
            }
            
            // Shaded area
            Path { path in
                let width = geometry.size.width * CGFloat(2 * octaveRange) / 10
                let leftX = percentage * geometry.size.width - width / 2
                let rect = CGRect(x: leftX, y: topSpace, width: width, height: geometry.size.height - bottomSpace - topSpace)
                path.addRoundedRect(in: rect, cornerSize: CGSize(width: 20, height: 20))
            }
            .foregroundColor(Color.teal.opacity(0.15))
            
            // Selected Line
            Path { path in
                let x = percentage * geometry.size.width
                path.move(to: CGPoint(x: x, y: topSpace))
                path.addLine(to: CGPoint(x: x, y: geometry.size.height - bottomSpace))
                
            }
                .stroke(Color.white, lineWidth: 2)
            
            // Selected Freq Label
            Text("\(freqDecimalString(freq))")
                .frame(width: labelWidth, height: 20, alignment: .center)
                .offset(x: percentage * geometry.size.width - labelWidth / 2, y: 0)
                .font(.system(size: 18, weight: .semibold))
                .foregroundColor(Color.white)
            
            Rectangle()
                .size(geometry.frame(in: .local).size)
                .foregroundColor(Color(white: 1, opacity: 0.001))
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { (value) in
                            let translation = value.translation.width - lastTranslation
                            let offset = translation / geometry.size.width
                            percentage += offset
                            lastTranslation = value.translation.width
                            print(lastTranslation)
                        }
                        .onEnded { _ in
                            lastTranslation = 0
                        }
                )
        }
        
    }
    
    func x(for freq: Float, width: CGFloat) -> CGFloat {
        let count = graphLineFreqs.count
        let octave = AudioCalculator.octave(fromFreq: freq)
        return width * CGFloat(octave) / CGFloat(count)
    }
    
    func lineXPositions(width: CGFloat) -> [CGFloat] {
        return graphLineFreqs.map { x(for: $0, width: width) }
    }

    
    private func freqIntString(_ freq: Float) -> String {
        if freq < 1000 {
            return String(Int(freq))
        } else {
            return "\(Int(freq / 1000))k"
        }
    }
    
    private func freqDecimalString(_ freq: Float) -> String {
        if freq / 1000.0 >= 1 {
            let freqString = String(freq / 1000.0)
            return freqString + " kHz"
        } else {
            return "\(Int(freq)) Hz"
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
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.init(white: 1, opacity: 0.5))
            Text("1 Octave")
                .font(.system(size: 18, weight: .heavy))
                .foregroundColor(.teal)
            
        }
    }
}

struct StatusBar: View {
    
    @ObservedObject var manager: EQDetectiveViewModel
    
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
        EQDetectiveGameplayView()
            .previewDevice("iPhone 12 Pro")
    }
}
