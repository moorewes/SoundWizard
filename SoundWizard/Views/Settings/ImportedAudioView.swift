//
//  ImportedAudioView.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/9/20.
//

import SwiftUI

struct ImportedAudioView: View {
    @ObservedObject var manager = UserAudioManager(store: CoreDataManager.shared)
    
    @State var showFileImporter = false
    @State var showConfirmImportView = false
    @State var fileURL: URL?
    @State var userProvidedName = ""
    
    var body: some View {
        VStack {
            List {
                ForEach(manager.audioFiles) { file in
                    NavigationLink(
                        destination: Text("Destination"),
                        label: {
                            Text(file.name)
                                .font(.std(.headline))
                                .foregroundColor(.white)
                        })
                }
                .onDelete { indexSet in
                    indexSet.forEach { manager.remove(at: $0) }
                }
                .listRowBackground(Color.secondaryBackground)
            
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarTitle("Imported Audio", displayMode: .inline)
            .navigationBarItems(trailing: addButton)

            Spacer()
        }
        .background(Gradient.background.ignoresSafeArea())
        .fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.audio]) { result in
            do {
                fileURL = try result.get()
                showConfirmImportView = true
            } catch {
                print(error.localizedDescription)
            }
        }
        .sheet(isPresented: $showConfirmImportView, content: {
            AudioImportConfirmationView(
                isPresented: $showConfirmImportView,
                fileTitle: $userProvidedName,
                placeholder: fileURL?.lastPathComponent ?? "") {
                    if let url = fileURL {
                        manager.importFile(url: url, name: userProvidedName)
                    }
                    showConfirmImportView = false
                }
        })
    }
    
    var addButton: some View {
        Button("+") {
            showFileImporter = true
        }
        .font(.std(.title))
        .padding(.trailing, 15)
    }
    
    
}

struct AudioImportConfirmationView: View {
    
    @Binding var isPresented: Bool
    @Binding var fileTitle: String
    let placeholder: String
    let confirmHandler: () -> Void
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    Text("Name")
                        .foregroundColor(.lightGray)
                        .font(.std(.subheadline))
                    Spacer()
                    TextField(placeholder, text: $fileTitle)
                        .foregroundColor(.white)
                        .font(.std(.subheadline))
                        .listRowBackground(Color.secondaryBackground)
                        .multilineTextAlignment(.trailing)
                }
                .background(Color.secondaryBackground)
                .listRowBackground(Color.secondaryBackground)
                
            }
            .listStyle(InsetGroupedListStyle())
            .navigationBarItems(leading: leadingNavItem, trailing: trailingNavItem)
            .navigationBarTitle("Import Audio")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                
            }
        }
    }
    
    var leadingNavItem: some View {
        Button("Cancel") {
            isPresented = false
        }
    }
    var trailingNavItem: some View {
        Button("Import") {
            if fileTitle.isEmpty {
                fileTitle = placeholder
            }
            confirmHandler()
            
        }
    }
    
}

struct ImportedAudioView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ImportedAudioView()
        }
    }
}

//struct ImportedAudioView_Previews: PreviewProvider {
//    static var previews: some View {
//        AudioImportConfirmationView(isPresented: .constant(true), fileTitle: .constant("name"),placeholder: "placeholder") {}
//    }
//}

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
