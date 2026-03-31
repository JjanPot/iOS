//
//  FeedHeaderView.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import SwiftUI

struct FeedHeaderView: View {
    var body: some View {
        HStack {
            Text("2027.08.15")
                .font(.pretendard(.semiBold, size: 16))
            Spacer()
                
        }
        .padding(.bottom, 12)
    }
}

struct FeedBottomView: View {
    var body: some View {
        Spacer()
            .frame(height: 40)
    }
}

#Preview {
    FeedHeaderView()
}
