//
//  FrequencyGraphView.swift
//  SoundWizard
//
//  Created by Wes Moore on 10/26/20.
//

import UIKit

@IBDesignable
class FrequencyGraphView: UIView {
    
    // MARK - Properties
    
    // MARK: Internal
    
    lazy var currentLineXPosition: CGFloat = xPosition(forFreq: 1000.0)
    var currentFreq: Float { return freq(forXPosition: currentLineXPosition) }
    
    // MARK: IB Inspectable
    
    @IBInspectable var currentLineColor: UIColor = UIColor.white
    @IBInspectable var currentLineWidth: CGFloat = 3.0
    @IBInspectable var currentAreaColor: UIColor = UIColor.init(white: 1, alpha: 0.1)
    
    @IBInspectable var graphLineColor: UIColor = UIColor.systemTeal
    @IBInspectable var graphLineWidth: CGFloat = 1.0
    @IBInspectable var octaveRange: CGFloat = 10.0
    
    @IBInspectable var solutionLineJustMissedColor: UIColor = UIColor.systemOrange
    @IBInspectable var solutionLineSuccessColor: UIColor = UIColor.systemGreen
    @IBInspectable var solutionLineFailColor: UIColor = UIColor.systemRed
    
    // MARK: Private
    
    private var initialFreq: Float = 1000.0
    private var solutionLineColor = UIColor.systemGreen
    private var octaveErrorRange: CGFloat = 0.0
    private var guessedLineXPosition: CGFloat?
    private var solutionLineXPosition: CGFloat?
    private var graphTopY: CGFloat = 40.0
    private var graphBottomY: CGFloat { return bounds.height - 25 }
    private var shadedAreaWidth: CGFloat = 100
    private var graphLineFreqs: [Float] = [31, 62, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
    
    // MARK: - Drawing
        
    override func draw(_ rect: CGRect) {
        drawGraphLines()
        shadeCurrentArea()
        
        if let xGuess = guessedLineXPosition,
           let xSolution = solutionLineXPosition {
            drawSolutionLine(at: xSolution)
            drawGuessedDottedLine(at: xGuess)
        }
        
        drawCurrentLine()
    }
    
    // MARK: - Methods
    
    // MARK: Internal
    
    func setUp(for level: EQDetectiveLevel) {
        octaveErrorRange = CGFloat(level.octaveErrorRange * 2)
        shadedAreaWidth = octaveErrorRange * bounds.width / octaveRange
        setNeedsDisplay()
    }
    
    func updateCurrentFreq(x: CGFloat) {
        currentLineXPosition = x
        currentLineXPosition = currentLineXPosition.clamped(to: 0.0...bounds.width)
        setNeedsDisplay()
    }
    
    func updateCurrentFreq(movement: CGFloat) {
        currentLineXPosition += movement
        currentLineXPosition = currentLineXPosition.clamped(to: 0.0...bounds.width)
        setNeedsDisplay()
    }
    
    func showSolution(successLevel: ScoreSuccessLevel) {
        solutionLineColor = lineColor(for: successLevel)
        guessedLineXPosition = currentLineXPosition
        setNeedsDisplay()
    }
    
    func reset(solutionFreq: Float) {
        solutionLineXPosition = xPosition(forFreq: solutionFreq)
        self.guessedLineXPosition = nil
        setNeedsDisplay()
    }
    
    // MARK: Helper - Calculations
    
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
    
    private func lineColor(for successLevel: ScoreSuccessLevel) -> UIColor {
        switch successLevel {
        case .perfect, .great, .fair:
            return solutionLineSuccessColor
        case .justMissed:
            return solutionLineJustMissedColor
        case .failed:
            return solutionLineFailColor
        }
    }
    
    // MARK: Helper - Drawing
    
    private func shadeCurrentArea() {
        let leftX = currentLineXPosition - shadedAreaWidth / 2
        let rect = CGRect(x: leftX, y: graphTopY, width: shadedAreaWidth, height: graphBottomY - graphTopY)
        let path = UIBezierPath(roundedRect: rect, cornerRadius: 5)
        
        currentAreaColor.setFill()
        
        path.fill()
    }
    
    private func drawGuessedDottedLine(at x: CGFloat) {
        let path = UIBezierPath()
        path.lineWidth = 1
        path.setLineDash([8, 8], count: 2, phase: 0)
        UIColor(white: 1, alpha: 0.8).setStroke()
        
        path.move(to: CGPoint(x: x, y: graphTopY))
        path.addLine(to: CGPoint(x: x, y: graphBottomY))
        
        path.stroke()
    }
    
    private func drawCurrentLine() {
        let path = UIBezierPath()
        path.lineWidth = currentLineWidth
        currentLineColor.set()
        
        let x = currentLineXPosition
        path.move(to: CGPoint(x: x, y: graphTopY))
        path.addLine(to: CGPoint(x: x, y: graphBottomY))
        
        path.stroke()
    }
    
    private func drawSolutionLine(at x: CGFloat) {
        let path = UIBezierPath()
        path.lineWidth = currentLineWidth
        
        solutionLineColor.setStroke()
        
        path.move(to: CGPoint(x: x, y: graphTopY))
        path.addLine(to: CGPoint(x: x, y: graphBottomY))
        
        path.stroke()
    }
    
    private func drawGraphLines() {
        let path = UIBezierPath()
        path.lineWidth = graphLineWidth
        graphLineColor.set()
                
        for i in graphLineFreqs {
            let x = xPosition(forFreq: i)
            path.move(to: CGPoint(x: x, y:graphTopY))
            path.addLine(to: CGPoint(x: x, y: graphBottomY))
        }
        
        path.stroke()
    }

}
