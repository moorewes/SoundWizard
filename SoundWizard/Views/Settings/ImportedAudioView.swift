//
//  ImportedAudioView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/9/20.
//

import SwiftUI

struct ImportedAudioView: View {
    
    @ObservedObject var manager = UserAudioManager()
    
    var body: some View {
        Text("hi")
    }
}

struct ImportedAudioView_Previews: PreviewProvider {
    static var previews: some View {
        ImportedAudioView()
    }
}

class UserAudioManager: ObservableObject {
    

    
}

class UserAudioStore {
    
}
