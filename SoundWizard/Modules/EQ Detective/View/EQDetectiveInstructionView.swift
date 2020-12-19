//
//  EQDetectiveInstructionView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/17/20.
//

import SwiftUI

struct EQDetectiveInstructionView: View {
    
    var level: EQDLevel
    
    var body: some View {
        TabView {
            instructions
        }
        .tabViewStyle(PageTabViewStyle())
    }
    
    var instructions: some View {
        HStack {
            VStack {
                bellPath(size: CGSize(width: 60, height: 20))
                    .stroke(lineWidth: 1.5)
                    .foregroundColor(.teal)
                    .frame(width: 60, height: 20, alignment: .center)
                    .padding(.bottom, 10)
                Text(filterGainDescription)
                    .font(.std(.callout))
                Text(level.bandFocus.uiDescription)
                    .font(.std(.callout))
                Text("Q: \(Int(level.filterQ))")
                    .font(.std(.callout))
            }
            .padding()
            
            Text("Guess the center frequency of the EQ filter")
                .font(.std(.callout))
                .multilineTextAlignment(.center)
                .padding()
        }
        
    }
    
    private var filterGainDescription: String {
        let gain = Int(level.filterGain)
        let suffix = gain > 0 ? "Peak" : "Cut"
        return "\(gain)dB \(suffix)"
    }
    
    private func bellPath(size: CGSize) -> Path {
        var path = Path()
        let start = bellStart(size: size)
        let endX = size.width - start.x
        path.move(to: start)
        for i in stride(from: start.x, through: endX, by: 1) {
            let i = CGFloat(i)
            let y = bellY(x: i, size: size)
            path.addLine(to: CGPoint(x: i, y: y))
        }
        
        return path
    }
    
    private func bellY(x: CGFloat, size: CGSize) -> CGFloat {
        let a = CGFloat(level.filterGain * 1.5)
        let b = size.width / 2
        let c = size.width / (3 * CGFloat(level.filterQ))
        let startY = bellStart(size: size).y
        return startY - a * exp(-pow(x - b, 2) / (2 * pow(c, 2)))
    }
    
    private func bellStart(size: CGSize) -> CGPoint {
        let y = level.filterGain < 0 ? size.height / 4 : size.height
        return CGPoint(x: 0, y: y)
    }
    
}

//
//struct EQDetectiveInstructionView_Previews: PreviewProvider {
//    static var previews: some View {
//        EQDetectiveInstructionView(level: EQDetectiveLevel.level(1)!)
//            .preferredColorScheme(.dark)
//            .foregroundColor(.lightGray)
//    }
//}
