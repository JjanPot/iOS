//
//  ChallengeInProgressView.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//

import Foundation
import SwiftUI

// MARK: 챌린지 진행중
struct ChallengeInProgressView : View {
    let viewData: ChallengeInProgressViewData
    let onAction: (ChallengeCardAction) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            
            VStack(alignment: .leading, spacing: 8) {
                // 챌린지 상태
                BadgeView(title: "종료일까지 \(viewData.dday)")
                
                // 팀이름
                Text(viewData.teamName)
                    .font(.pretendard(.semiBold, size: 26))
                    .foregroundStyle(Color.black900)
                
                // in Progress - 절액금액
                HStack {
                    Text("팀 절약")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(Color.black500)
                    Spacer()
                    Text("\(viewData.teamSavingsAmount)원")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(Color.orange600)
                }
                HStack {
                    Text("개인 절약")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(Color.black500)
                    Spacer()
                    Text("\(viewData.personalSavingsAmount)원")
                        .font(.pretendard(.medium, size: 14))
                        .foregroundStyle(Color.black900)
                    
                }
            }
            // spacing: 18
            
            // 상세정보 버튼 (두개)
            HStack(spacing: 10){
                CapsuleButton(title: "상세 정보", colorType: .border, isDisabled: false){
                    onAction(.detail(challengeId: viewData.challengeId))
                }
                CapsuleButton(title: "인증하기", colorType: .fill, isDisabled: false){
                    onAction(.submitSavingsProof(challengeId: viewData.challengeId))
                }
            }
        }
    }
}
