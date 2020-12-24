//
//  MultiPickerRow.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/23/20.
//

import SwiftUI

struct MultiPickerRow<Item: UIDescribing & Hashable>: View {
    let title: String
    let items: [Item]
    @Binding var selectedItems: [Item]
    
    var body: some View {
        print(selectedItems.map { $0.uiDescription })
        return NavigationLink(
            destination: DetailView(items: items, selection: $selectedItems),
            label: {
                HStack {
                    Text(title)
                        .font(.std(.subheadline))
                        .foregroundColor(.white)
                    Spacer()
                    Text(description)
                        .font(.std(.subheadline))
                        .foregroundColor(.lightGray)
                        .padding(.trailing, 15)
                }
            }
        )
        .listRowBackground(Color.secondaryBackground)
    }
    
    var description: String {
        selectedItems.count == 1 ? selectedItems[0].uiDescription : "Multiple"
    }
}

extension MultiPickerRow {
    struct DetailView: View {
        @Environment(\.presentationMode) var presentation
        let items: [Item]
        @Binding var selection: [Item]
        
        var body: some View {
            List {
                ForEach(items, id: \.self) { item in
                    Button(action: { handleSelection(item) }, label: {
                        HStack {
                            Text(item.uiDescription)
                                .font(.std(.subheadline))
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "checkmark")
                                .font(.std(.footnote))
                                .foregroundColor(.white)
                                .opacity(selection.contains(item) ? 1 : 0)
                        }
                    })
                }
                .listRowBackground(Color.secondaryBackground)
            }
        }
        
        private func handleSelection(_ item: Item) {
            if selection.count == 1,
               selection[0] == item {
                return
            }
            if let index = selection.firstIndex(of: item) {
                selection.remove(at: index)
            } else {
                selection.append(item)
            }
        }
    }
}
