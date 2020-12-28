//
//  ValueText.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/27/20.
//

import SwiftUI

extension EQMatchGameplayView.FilterInfo {
    struct ValuesRow: View {
        let guess: String
        let unit: String
        let solution: String
        let solutionColor: Color
        let valueCharCount = 4
        
        init(data: RowData) {
            self.guess = data.guess.padded(to: valueCharCount)
            self.unit = data.unit
            self.solution = (data.solution ?? "").padded(to: valueCharCount)
            self.solutionColor = data.solutionColor ?? Color.clear
        }
        
        var body: some View {
            HStack {
                Text(solution)
                    .font(.mono(.headline))
                    .foregroundColor(solutionColor)
                    .padding(.leading)
                Text(guess)
                    .font(.mono(.headline))
                    .foregroundColor(.white)
                Text(unit)
                    .font(.std(.subheadline))
                    .foregroundColor(.teal)
            }
        }
    }
    
    struct RowData {
        var guess: String
        var unit: String
        var solution: String?
        var solutionColor: Color?
    }
}
extension String {
    func padded(to count: Int) -> String {
        var result = self
        while result.count < count {
            result.insert(" ", at: result.startIndex)
        }
        return result
    }
}

struct ValuesRow_Previews: PreviewProvider {
    static var data = [
        EQMatchGameplayView.FilterInfo.RowData(
            guess: "2", unit: "dB", solution: "3", solutionColor: .green
        ),
        EQMatchGameplayView.FilterInfo.RowData(
            guess: "400", unit: "Hz", solution: "600", solutionColor: .red
        ),
        EQMatchGameplayView.FilterInfo.RowData(
            guess: "2", unit: "dB", solution: nil, solutionColor: nil
        ),
        EQMatchGameplayView.FilterInfo.RowData(
            guess: "400", unit: "Hz", solution: nil, solutionColor: nil
        )
    ]
    static var previews: some View {
        HStack {
            VStack {
                EQMatchGameplayView.FilterInfo.ValuesRow(data: data[0])
                EQMatchGameplayView.FilterInfo.ValuesRow(data: data[1])
            }
            Spacer()
            VStack {
                EQMatchGameplayView.FilterInfo.ValuesRow(data: data[2])
                EQMatchGameplayView.FilterInfo.ValuesRow(data: data[3])
            }
            Spacer()
        }
        
        //.frame(width: nil, height: 60, alignment: .center)
    }
}
