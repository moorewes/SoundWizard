//
//  PickerRow.swift
//  SoundWizard
//
//  Created by Wes Moore on 12/23/20.
//

import SwiftUI

protocol UIDescribing {
    var uiDescription: String { get }
}

struct PickerRow<Item: UIDescribing & Hashable>: View {
    let title: String
    let items: [Item]
    @Binding var selectedItem: Item
    
    var body: some View {
        NavigationLink(
            destination: DetailView(selection: $selectedItem, items: items),
            label: {
                HStack {
                    Text(title)
                        .font(.std(.subheadline))
                        .foregroundColor(.white)
                    Spacer()
                    Text(selectedItem.uiDescription)
                        .font(.std(.subheadline))
                        .foregroundColor(.lightGray)
                        .padding(.trailing, 15)
                }
            }
        )
        .listRowBackground(Color.secondaryBackground)
    }
}

extension PickerRow {
    struct DetailView: View {
        @Environment(\.presentationMode) var presentation
        @Binding var selection: Item
        let items: [Item]
        var titles: [String] {
            items.map { $0.uiDescription }
        }
        
        var body: some View {
            List {
                ForEach(items, id: \.self) { item in
                    Button(action: {
                        selection = item
                        presentation.wrappedValue.dismiss()
                    }, label: {
                        HStack {
                            Text(item.uiDescription)
                                .font(.std(.subheadline))
                                .foregroundColor(.white)
                            Spacer()
                            Image(systemName: "checkmark")
                                .font(.std(.footnote))
                                .foregroundColor(.white)
                                .opacity(selection == item ? 1 : 0)
                        }
                    })
                }
                .listRowBackground(Color.secondaryBackground)
            }
        }
    }
}
