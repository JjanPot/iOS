//
//  MenuSection.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//


import SwiftUI

struct MenuSection<Content: View>: View {
    let title: String
    let content: () -> Content
    init(_ title: String, @ViewBuilder content: @escaping () -> Content) {
        self.title = title
        self.content = content
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(title)
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(.black900)
            content()
        }
    }
}

