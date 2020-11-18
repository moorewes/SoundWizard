//
//  EQDetectiveInstructionView.swift
//  SoundWizard
//
//  Created by Wes Moore on 11/5/20.
//

import UIKit

@IBDesignable
class EQDetectiveInstructionUIView: UIView {
    
    // MARK: - Properties
    
    // MARK: Internal
    
    var bellGainDB: Float = 10
    
    // MARK: Private
    
    private var bellLeftX: CGFloat = 50.0
    private var bellRightX: CGFloat { bounds.width - bellLeftX }
    private var bellStartY: CGFloat { bounds.height / 2 }
    private var bellStart: CGPoint { CGPoint(x: bellLeftX, y: bellStartY) }
    private var bellWidth: CGFloat { return bounds.width / 12 }
    private var bellHeight: CGFloat { return CGFloat(bellGainDB) * 5.0 }
    
    // MARK: - Drawing

    override func draw(_ rect: CGRect) {
        drawBellCurve()
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func bellPeakY() -> CGFloat {
        return bell(x: bounds.width / 2)
    }
    
    // MARK: Helper
    
    private func drawBellCurve() {
        let path = UIBezierPath()
        path.move(to: bellStart)
        for i in stride(from: bellLeftX, through: bellRightX, by: 1) {
            let i = CGFloat(i)
            let y = bell(x: i)
            path.addLine(to: CGPoint(x: i, y: y))
        }
        UIColor.systemTeal.setStroke()
        path.lineWidth = 2
        path.stroke()
    }

    private func bell(x: CGFloat) -> CGFloat {
        let a = bellHeight
        let b = bounds.width / 2
        let c = bellWidth
        return bellStart.y - a * exp(-pow(x - b, 2) / (2 * pow(c, 2)))
    }

}
