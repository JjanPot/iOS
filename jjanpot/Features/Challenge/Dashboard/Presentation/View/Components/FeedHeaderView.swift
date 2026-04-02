//
//  FeedHeaderView.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import SwiftUI

struct FeedHeaderView: View {
    let title: String
    var body: some View {
        HStack {
            Text(title)
                .font(.pretendard(.semiBold, size: 16))
            Spacer()
                
        }
    }
}

struct FeedBottomView: View {
    var body: some View {
        Spacer()
            .frame(height: 40)
    }
}

#Preview {
    FeedHeaderView(
        title: "2027.08.15"
    )
}
