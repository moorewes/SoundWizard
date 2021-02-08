//
//  SectionHeader.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/25/21.
//

import SwiftUI

struct SectionSimpleHeader: View {
    let title: String
    
    var body: some View {
        HStack {
            HeaderTitle(title: title)
            Spacer()
        }
        .padding()
    }
}

struct SectionActionHeader<Content: View>: View {
    let title: String
    let accessory: () -> Content
    
    var body: some View {
        HStack {
            HeaderTitle(title: title)
            Spacer()
            accessory()
        }.padding()
    }
}

fileprivate struct HeaderTitle: View {
    let title: String
    var body: some View {
        Text(title)
            .font(.std(.title))
    }
}

struct SectionHeader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SectionSimpleHeader(title: "Title")
                .padding()
            
            SectionActionHeader(title: "Title 2") {
                Image(systemName: "gearshape.fill")
            }
            .padding()
        }
    }
}
