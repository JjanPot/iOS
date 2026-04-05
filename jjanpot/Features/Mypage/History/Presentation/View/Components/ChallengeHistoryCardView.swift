//
//  ChallengeHistoryCardView.swift
//  jjanpot
//
//  Created by 임주희 on 4/5/26.
//

import SwiftUI

struct ChallengeHistoryCardView: View {
    let viewData: ChallengeHistoryCardViewData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            
            // 챌린지 상태
            BadgeView(title: viewData.statusDisplayName)
            
            // 팀이름
            Text(viewData.teamName)
                .font(.pretendard(.semiBold, size: 26))
                .foregroundStyle(Color.black900)
            
            // 부제
//            Text
//                .font(.pretendard(.regular, size: 14))
//                .foregroundStyle(Color.black500)
            
            // waiting - 챌린지 기간
            Text(viewData.period)
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(Color.black600)
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.orange100)
        .rounded(radius: 12)
        .roundedBorder(color: .orange300, radius: 12)
    }
}
