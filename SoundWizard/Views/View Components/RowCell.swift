//
//  RowCell.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/25/21.
//

import SwiftUI

struct RowCell<Content: View>: View {
    let content: () -> Content
    
    var body: some View {
        content()
            //.padding(.horizontal)
            .frame(height: height)
            .background(Color.secondaryBackground)
            .cornerRadius(cornerRadius)
            .padding()
    }
    
    private let cornerRadius: CGFloat = 10
    private let height: CGFloat = 60
}

struct NavigationRowCell<Destination: View>: View {
    let title: String
    let destination: () -> Destination
    
    var body: some View {
        NavigationLink(destination: destination()) {
            RowCell {
                HStack {
                    Text(title)
                        .font(.std(.headline))
                        .foregroundColor(.white)
                    Spacer()
                    RightChevronImage()
                        .font(.std(.body))
                        .foregroundColor(.darkGray)
                }
                .padding()
            }
        }
    }
}

struct RowCell_Previews: PreviewProvider {
    static var previews: some View {
        RowCell {
            HStack {
                
            }
        }
    }
}
