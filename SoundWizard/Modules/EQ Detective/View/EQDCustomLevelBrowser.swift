//
//  EQDCustomLevelBrowser.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/23/20.
//

import SwiftUI

class CustomLevels: ObservableObject {
    @Published var levels: [EQDLevel] = []
    var selectedLevel: EQDLevel? {
        get {
            if let index = selectedIndex {
                return levels[index]
            } else {
                return nil
            }
        }
        set {
            if let index = selectedIndex,
               let level = newValue {
                levels[index] = level
            }
        }
    }
    
    var selectedIndex: Int?
}

struct EQDCustomLevelBrowser: View {
    
    @ObservedObject var controller = CustomLevels()
    @State var levels: [EQDLevel]
    @State var selectedLevel: EQDLevel?
    
    var body: some View {
        List {
            ForEach(levels) { level in
                NavigationLink(
                    destination: EQDCustomLevelDetailView(level: level) { updatedLevel in
                        if let index = levels.firstIndex(where: {$0.id == level.id}) {
                            levels[index] = updatedLevel
                        }
                    },
                    label: {
                        Text(level.id)
                            .font(.std(.body))
                            .foregroundColor(.white)

                    })
            }
            .listRowBackground(Color.secondaryBackground)
            
        }
        .listStyle(InsetGroupedListStyle())
        .navigationBarTitle("Custom Levels")
        .navigationBarItems(trailing: addLevelButton)
        .sheet(item: $controller.selectedLevel) { level in
            NavigationView {
                EQDCustomLevelDetailView(level: level) { updatedLevel in
                    if let index = levels.firstIndex(where: {$0.id == level.id}) {
                        levels[index] = updatedLevel
                        selectedLevel = nil
                    }
                }
            }
        }
        
//        .sheet(item: $selectedLevel) { level in
//            EQDCustomLevelDetailView(level: level)
//        }
    }
    
    var addLevelButton: some View {
        Button("+") {
            let level = EQDLevel.newCustomLevel()
            levels.append(level)
            selectedLevel = level
        }
            .font(.std(.title2))
            .foregroundColor(.teal)
            .padding(.trailing, 10)
        
    }

}

struct EQDCustomLevelBrowser_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EQDCustomLevelBrowser(levels: [])
        }
        .onAppear {
            Appearance.setup()
        }
    }
}
