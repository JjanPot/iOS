//
//  MenuButton.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//

import SwiftUI

struct MenuButton: View {
    let title: String
    let action: ()->Void
    init(_ title: String, action: @escaping ()->Void) {
        self.title = title
        self.action = action
    }
    var body: some View {
        Button {
            action()
        } label: {
            HStack(alignment: .center){
                Text(title)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(.black600)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(.black600)
            }
        }
    }
}
