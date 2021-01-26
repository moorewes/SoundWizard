//
//  EQDCustomLevelDetailView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/23/20.
//

import SwiftUI

struct EQDCustomLevelDetailView: View {
    @Environment(\.presentationMode) var presentation
    @State var level: EQDLevel
    let completionHandler: (EQDLevel) -> Void
    var audioFiles: [AudioMetadata] = CoreDataManager.shared.allAudioFiles()
    @State var name: String = ""
    @State var selectedAudioFiles = [AudioMetadata]()
    @State var bandFocus: BandFocus = .all
    @State var filter: FilterData = FilterData(gain: 9, q: 8)
    
    var body: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                    .listRowBackground(Color.secondaryBackground)
            }
           
            MultiPickerRow(title: "Audio", items: audioFiles, selectedItems: $level.audioMetadata)
            
            PickerRow(title: "Band Focus", items: BandFocus.allCases, selectedItem: $level.bandFocus)
            
            PickerRow(title: "Filter", items: filterDataChoices, selectedItem: $filter)
        }
        .navigationBarTitle("Edit Level")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: saveButton)
        
    }
    
    var saveButton: some View {
        Button("Save") {
            var level = self.level
            level.id = name.isEmpty ? Date().description : name
            level.audioMetadata = selectedAudioFiles
            level.bandFocus = bandFocus
            level.filterGain = Gain(dB: Double(filter.gain))
            level.filterQ = Double(filter.q)
            completionHandler(level)
            presentation.wrappedValue.dismiss()
        }
    }
    
    let filterDataChoices: [FilterData] = [
        FilterData(gain: 9, q: 8),
        FilterData(gain: 6, q: 5),
        FilterData(gain: 3, q: 2),
        FilterData(gain: -3, q: 2),
        FilterData(gain: -6, q: 4),
        FilterData(gain: -9, q: 6),
        FilterData(gain: -12, q: 9)
    ]
    
}

struct FilterData: UIDescribing, Hashable {
    let gain: Int
    let q: Int
    
    var isBoost: Bool { gain > 0 }
    var uiDescription: String {
        "\(gain)dB, Q: \(q)"
    }
}

struct EQDCustomLevelDetailView_Previews: PreviewProvider {
    
    static let newLevel = EQDLevel.newCustomLevel()
    
    static var previews: some View {
        Appearance.setup()
        //UITableViewCell.appearance()
        return NavigationView {
            EQDCustomLevelDetailView(level: EQDLevel.newCustomLevel()) {_ in }
        }
        
    }
}

extension EQDLevel {
    
    static func newCustomLevel() -> EQDLevel {
        EQDLevel(id: UUID().uuidString, game: .eqDetective, number: -1, difficulty: .custom, audioMetadata: [], scoreData: ScoreData(starScores: [300, 500, 700], scores: []), bandFocus: .all, filterGain: Gain(dB: 9), filterQ: 8, octaveErrorRange: 2)
    }
    
}
