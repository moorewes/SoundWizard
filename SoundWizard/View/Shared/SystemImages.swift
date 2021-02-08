//
//  SystemImages.swift
//  SoundWizard
//
//  Created by Wes Moore on 1/25/21.
//

import SwiftUI

struct StarImage: View {
    var earned = true
    var body: some View {
        Image(systemName: "star.fill")
            .foregroundColor(earned ? .yellow : .primaryBackground)
    }
}

struct RightChevronImage: View {
    var body: some View {
        Image(systemName: "chevron.right")
    }
}

struct StarImage_Previews: PreviewProvider {
    static var previews: some View {
        StarImage()
    }
}
