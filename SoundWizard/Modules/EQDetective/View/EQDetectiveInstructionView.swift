//
//  EQDetectiveInstructionView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/17/20.
//

import SwiftUI

struct EQDetectiveInstructionView: View {
    
    var level: EQDetectiveLevel
    
    init(level genericLevel: Level) {
        level = genericLevel as! EQDetectiveLevel
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                bellPath(size: geometry.size)
                    .stroke(lineWidth: 3)
                
                Text("\(level.filterGainDB.uiString) dB")
                    .font(.monoSemiBold(22))
                    .offset(dBLabelOffset(size: geometry.size))
                
                Text("Can you find the\ncenter frequency?")
                    .font(.monoMedium(18))
                    .offset(instructionLabelOffset(size: geometry.size))
                    .multilineTextAlignment(.center)
                
            }
        }
    }
    
    private func dBLabelOffset(size: CGSize) -> CGSize {
        let sizeWithoutHeight = CGSize(width: size.width, height: 0)
        var height = bell(x: size.width / 2, size: sizeWithoutHeight)
        height += level.filterGainDB > 0 ? -30 : 30
        return CGSize(width: 0, height: height)
    }
    
    private func instructionLabelOffset(size: CGSize) -> CGSize {
        var size = dBLabelOffset(size: size)
        size.height *= -1
        return size
    }
    
    private func bellPath(size: CGSize) -> Path {
        var path = Path()
        let start = bellStart(size: size)
        let endX = size.width - start.x
        path.move(to: start)
        for i in stride(from: start.x, through: endX, by: 1) {
            let i = CGFloat(i)
            let y = bell(x: i, size: size)
            path.addLine(to: CGPoint(x: i, y: y))
        }
        
        return path
    }
    
    private func bell(x: CGFloat, size: CGSize) -> CGFloat {
        let a = CGFloat(level.filterGainDB * 5.0)
        let b = size.width / 2
        let c = size.width / 12
        let startY = bellStart(size: size).y
        return startY - a * exp(-pow(x - b, 2) / (2 * pow(c, 2)))
    }
    
    private func bellStart(size: CGSize) -> CGPoint {
        return CGPoint(x: 50.0, y: size.height / 2)
    }
    
}
//
//struct BellCurveView: View {
//
//    var height: CGFloat
//
//}

struct EQDetectiveInstructionView_Previews: PreviewProvider {
    static var previews: some View {
        EQDetectiveInstructionView(level: EQDetectiveLevel.level(0)!)
    }
}
