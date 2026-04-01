//
//  PostTitleView.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import SwiftUI

struct PostTitleView: View {
    let title: String
    let isNeccessary: Bool
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 1) {
            HStack(spacing: .zero) {
                Text(title)
                    .font(.pretendard(.semiBold, size: 14))
                    .foregroundStyle(Color.black500)
                
                if isNeccessary {
                    Text(" *")
                        .font(.pretendard(.semiBold, size: 14))
                        .foregroundStyle(Color.red500)
                }
            }
        }
    }
}
#Preview {
    PostTitleView(title: "금액", isNeccessary: true)
}
