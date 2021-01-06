//
//  EQMatchLevelBuilderView.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/5/21.
//

import SwiftUI

struct EQMatchLevelBuilderView: View {
    var audioChoices: [AudioMetadata]
    @State private var format = EQMatchLevel.Format.defaultFormat
    @State var audio = [AudioMetadata]()
    
    var body: some View {
        NavigationView {
            Form {
                PickerRow(title: "Band Count", items: BandCount.allCases, selectedItem: $format.bandCount)
                
                PickerRow(title: "Band Focus", items: BandFocus.allCases, selectedItem: $format.bandFocus)
                
                PickerRow(title: "Mode", items: EQMatchLevel.Mode.allCases, selectedItem: $format.mode)
                
                MultiPickerRow(title: "Audio", items: audioChoices, selectedItems: $audio)
            }
            .navigationBarTitle("Create Level")
        }
    }
}

extension EQMatchLevelBuilderView {
    init(audioMetadata: [AudioMetadata]) {
        audioChoices = audioMetadata
        audio = audioMetadata
    }
}

private extension EQMatchLevel.Format {
    static var defaultFormat: EQMatchLevel.Format {
        EQMatchLevel.Format(mode: .free, bandCount: .single, bandFocus: .all)
    }
}

struct EQMatchLevelBuilderView_Previews: PreviewProvider {
    static var previews: some View {
        EQMatchLevelBuilderView(audioMetadata: [TestData.audioMetadata])
    }
}
