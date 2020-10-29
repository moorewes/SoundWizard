//
//  FrequencyGraphView.swift
//  AudioKitExperiments
//
//  Created by Wes Moore on 10/26/20.
//

import UIKit

@IBDesignable
class FrequencyGraphView: UIView {
    
    // MARK - Properties
    
    @IBInspectable var currentLineColor: UIColor = UIColor.white
    @IBInspectable var currentLineWidth: CGFloat = 3
    @IBInspectable var currentAreaColor: UIColor = UIColor.init(white: 1, alpha: 0.1)
    
    @IBInspectable var graphLineColor: UIColor = UIColor.systemTeal
    @IBInspectable var graphLineWidth: CGFloat = 1
    @IBInspectable var octaveRange: CGFloat = 10
    
    @IBInspectable var solutionLinePerfectColor: UIColor = UIColor.green
    @IBInspectable var solutionLineSuccessColor: UIColor = UIColor.yellow
    @IBInspectable var solutionLineFailColor: UIColor = UIColor.red
    
    var currentLineXPosition: CGFloat = 200
    var guessedLineXPosition: CGFloat?
    
    var solutionFreq: Float = 0
    var octaveError: Float = 0
    
    private var graphBottomY: CGFloat { return bounds.height - 40 }
    private var shadedAreaWidth: CGFloat { return octaveErrorRange * bounds.width / octaveRange }
    
    var octaveErrorRange: CGFloat = 4
    
    // MARK: - Methods
        
    override func draw(_ rect: CGRect) {
        drawGraphLines()
        shadeCurrentArea()
        
        if let x = guessedLineXPosition {
            drawSolutionLine()
            drawGuessedDottedLine(at: x)
        }
        
        drawCurrentLine()
    }
    
    func setUp() {
        currentLineXPosition = xPosition(forFreq: 1000.0)
    }
    
    func updateCurrentFreq(movement: CGFloat) {
        currentLineXPosition += movement
        currentLineXPosition = currentLineXPosition.clamped(to: 0.0...bounds.width)
        setNeedsDisplay()
    }
    
    func showSolution() {
        guessedLineXPosition = currentLineXPosition
        let guessedFreq = freq(forXPosition: guessedLineXPosition!)
                
        octaveError = AudioCalculator.octave(fromFreq: guessedFreq, baseOctaveFreq: solutionFreq)
        setNeedsDisplay()
    }
    
    func reset(solutionFreq: Float) {
        self.solutionFreq = solutionFreq
        self.guessedLineXPosition = nil
        setNeedsDisplay()
    }
    
    func currentFreq() -> Float {
        return freq(forXPosition: currentLineXPosition)
    }
    
    // MARK: - Helper Methods
    
    private func xPosition(forFreq freq: Float) -> CGFloat {
        let octave = AudioCalculator.octave(fromFreq: freq)
        return xPostion(forOctave: octave)
    }
    
    private func xPostion(forOctave octave: Float) -> CGFloat {
        return bounds.width * CGFloat(octave) / octaveRange
    }
    
    private func freq(forXPosition x: CGFloat) -> Float {
        let octave = self.octave(forXPosition: x)
        return AudioCalculator.freq(fromOctave: octave)
    }
    
    private func octave(forXPosition x: CGFloat) -> Float {
        return Float(octaveRange * x / bounds.width)
    }
    
    private func shadeCurrentArea() {
        let leftX = currentLineXPosition - shadedAreaWidth / 2
        let rect = CGRect(x: leftX, y: 0, width: shadedAreaWidth, height: graphBottomY)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        
        currentAreaColor.setFill()
        
        path.fill()
    }
    
    private func drawGuessedDottedLine(at x: CGFloat) {
        let path = UIBezierPath()
        path.lineWidth = 1
        path.setLineDash([8, 8], count: 2, phase: 0)
        UIColor(white: 1, alpha: 0.8).setStroke()
        
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: graphBottomY))
        
        path.stroke()
    }
    
    private func drawCurrentLine() {
        let path = UIBezierPath()
        path.lineWidth = currentLineWidth
        currentLineColor.set()
        
        let x = currentLineXPosition
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: graphBottomY))
        
        path.stroke()
    }
    
    private func drawSolutionLine() {
        let path = UIBezierPath()
        path.lineWidth = currentLineWidth
        
        let error = abs(octaveError)
        
        if error > Float(octaveErrorRange) {
            solutionLineFailColor.set()
        } else if error < 0.2 {
            solutionLinePerfectColor.set()
        } else {
            solutionLineSuccessColor.set()
        }
        
        let x = xPosition(forFreq: solutionFreq)
        path.move(to: CGPoint(x: x, y: 0))
        path.addLine(to: CGPoint(x: x, y: graphBottomY))
        
        path.stroke()
    }
    
    private func drawGraphLines() {
        let path = UIBezierPath()
        path.lineWidth = graphLineWidth
        graphLineColor.set()
        
        let lines = CGFloat(octaveRange)
        
        for i in 0...Int(octaveRange) {
            let x = bounds.width / lines * CGFloat(i) + 1
            path.move(to: CGPoint(x: x, y:0))
            path.addLine(to: CGPoint(x: x, y: graphBottomY))
            
        }
        
        path.stroke()
    }


}
