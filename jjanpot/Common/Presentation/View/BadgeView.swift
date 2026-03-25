//
//  BadgeView.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

struct BadgeView: View {
    enum style {
        case fill
        case border
    }
    
    let title: String
    
    var body: some View {
        Text(title)
            .font(.pretendard(.semiBold, size: 12))
            .foregroundStyle(Color.orange600)
            .padding(.vertical, 10)
            .padding(.horizontal, 12)
            .background(Color.orange300)
            .clipShape(Capsule())
    }
}

#Preview {
    BadgeView(
        title: "대기중"
    )
}
