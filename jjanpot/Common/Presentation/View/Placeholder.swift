//
//  Placeholder.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import SwiftUI

struct Placeholder: View {
    let width: CGFloat
    let height: CGFloat
    init(width: CGFloat = 24, height: CGFloat = 24) {
        self.width = width
        self.height = height
    }
    var body: some View {
        ZStack(alignment: .center) {
            
            Color.black100
                
            Image("IconPic")
                .renderingMode(.template)
                .resizable()
                .foregroundStyle(Color.black400)
                .frame(width: width, height: height)
        }
    }
}

#Preview {
    Placeholder()
}
