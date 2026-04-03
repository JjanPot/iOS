//
//  ChallengeBasicInfoView.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//

import SwiftUI

// 기본 정보
struct ChallengeBasicInfoView: View {
    let viewData: ChallengeBasicInfoViewData?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 8) {
                Text(viewData?.teamName ?? "")
                    .font(.pretendard(.semiBold, size: 24))
                    .foregroundStyle(.black900)
                
                Text(viewData?.goals ?? "")
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(.black500)
            }
            
            VStack(alignment: .leading, spacing: 14) {
                detailView(title: "카테고리", content: viewData?.category ?? "")
                detailView(title: "목표금액", content: viewData?.teamTargetAmount ?? "")
                detailView(title: "개인금액", content: viewData?.personTargetAmound ?? "")
                detailView(title: "팀 유형", content: viewData?.relationshipType ?? "")
                detailView(title: "기간", content: viewData?.during ?? "")
                detailView(title: "팀 인원", content: viewData?.memberCount ?? "")
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .rounded(radius: 12)
    }
    
    private func detailView(title: String, content: String) -> some View {
        HStack(alignment: .center, spacing: 8){
            Text(title)
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(Color.black500)
                .frame(width: 55, alignment: .leading)
            
            Text(content)
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(Color.black900)
        }
    }
}

#Preview {
    ChallengeBasicInfoView(viewData: ChallengeBasicInfoViewData(
        teamName: "배달을 아껴요",
        goals: "30만원 목표로 1주 함께 절약하기",
        category: "외식/배달",
        teamTargetAmount: "30만원",
        personTargetAmound: "2만원 이상",
        relationshipType: "친구",
        during: "26.07.15 - 16.07.21(1주)",
        memberCount: "5명"
    ))
}
