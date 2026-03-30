//
//  MainHeader.swift
//  jjanpot
//
//  Created by 임주희 on 3/29/26.
//

import SwiftUI

struct MainHeader: View {
    var body: some View {
        HStack {
            Image("TextLogo")
                .resizable()
                .frame(width: 122, height: 18.49)
            Spacer()

            // TODO: 알람버튼
        }
        .padding(20)
    }
}

#Preview {
    MainHeader()
}
