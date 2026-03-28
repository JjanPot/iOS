//
//  TitleView.swift
//  jjanpot
//
//  Created by 임주희 on 3/28/26.
//

import SwiftUI

struct TitleView: View {
    let title: String
    let description: String
    let isNeccessary: Bool
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: .zero) {
                Text(title)
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(Color.black900)
                
                if isNeccessary {
                    Text(" *")
                        .font(.pretendard(.medium, size: 16))
                        .foregroundStyle(Color.red500)
                }
            }
            
            Text(description)
                .font(.pretendard(.medium, size: 12))
                .foregroundStyle(Color.black500)
        }
    }
}

#Preview {
    TitleView(title: "팀 이름", description: "우리 챌린지의 이름을 입력해주세요.", isNeccessary: true)
}
