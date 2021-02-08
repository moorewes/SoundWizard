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
        let valueColor: Color
        let valueCharCount = 4
        
        init(data: RowData) {
            self.guess = data.guess.padded(to: valueCharCount)
            self.unit = data.unit
            self.solution = (data.solution ?? "").padded(to: valueCharCount)
            self.valueColor = data.valueColor ?? Color.white
        }
        
        var body: some View {
            HStack {

                Text(guess)
                    .font(.mono(.subheadline))
                    .foregroundColor(.white)
                   // .padding(.leading)
                Text(unit)
                    .font(.std(.footnote))
                    .foregroundColor(.teal)
                Text(solution)
                    .font(.mono(.footnote))
                    .foregroundColor(valueColor)
                    //.padding(.leading)
            }
        }
    }
    
    struct RowData {
        var guess: String
        var unit: String
        var solution: String?
        var valueColor: Color?
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
            guess: "2", unit: "dB", solution: "3", valueColor: .green
        ),
        EQMatchGameplayView.FilterInfo.RowData(
            guess: "400", unit: "Hz", solution: "600", valueColor: .red
        ),
        EQMatchGameplayView.FilterInfo.RowData(
            guess: "2", unit: "dB", solution: nil, valueColor: nil
        ),
        EQMatchGameplayView.FilterInfo.RowData(
            guess: "400", unit: "Hz", solution: nil, valueColor: nil
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
    }
}
