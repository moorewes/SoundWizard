//
//  UserAudioManager.swift
//  SoundWizard
//
//  Created by Wes Moore on 2/8/21.
//

import Foundation

class UserAudioManager: ObservableObject {
    private var store: UserAudioStore
    
    @Published var audioFiles: [AudioMetadata] = []
    
    init(store: UserAudioStore) {
        self.store = store
        refreshData()
    }
    
    func importFile(url: URL, name: String) {
        store.addUserAudioFile(name: name, url: url)
        refreshData()
    }
    
    func remove(at index: Int) {
        store.removeUserAudioFile(audioFiles[index])
        refreshData()
    }
    
    func update(at index: Int) {
        
    }
    
    private func refreshData() {
        audioFiles = store.userAudioFiles
    }
    
}

protocol UserAudioStore {
    var userAudioFiles: [AudioMetadata] { get }
    func addUserAudioFile(name: String, url: URL)
    func removeUserAudioFile(_ metadata: AudioMetadata)
}
