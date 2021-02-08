//
//  Scratchpad.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/3/20.
//

import SwiftUI
import AudioKit

struct Scratchpad: View {
    
    var body: some View {
        NavigationView {
            ScrollView {
                Rectangle()
                    .foregroundColor(.ocean)
            }
//            .navigationBarTitle("Title")
//            .navigationBarItems(trailing:
//                Text("HI")
//            )
            .toolbar(content: {
                ToolbarItem(placement: ToolbarItemPlacement.navigation) {
                    Text("Title")
                }
            })
        }
    }
}

struct Scratchpad_Previews: PreviewProvider {
    static var previews: some View {
        Scratchpad()
            .preferredColorScheme(.dark)
    }
}
