//
//  ChallengePendingView.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//

import Foundation
import SwiftUI

// MARK: 챌린지 대기
struct ChallengePendingView : View {

    let viewData: ChallengeWaitingViewData
    let onAction: (ChallengeCardAction) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            VStack(alignment: .leading, spacing: 8) {
                // 챌린지 상태
                BadgeView(title: "대기중인 챌린지")
                
                // 팀이름
                Text(viewData.teamName)
                    .font(.pretendard(.semiBold, size: 26))
                    .foregroundColor(.black900)
                
                // 부제
                (
                    Text("\(viewData.targetSavingsAmount)만원")
                    .foregroundColor(.black700)
                 + Text(" 목표로 ")
                        .foregroundColor(.black500)
                 + Text("1주")
                    .foregroundColor(.black700)
                 + Text(" 동안 함께 절약하기")
                        .foregroundColor(.black500)
                )
                .font(.pretendard(.medium, size: 14))
                
                // waiting - 챌린지 기간
                Text(viewData.period)
                    .font(.pretendard(.medium, size: 14))
                    .foregroundStyle(Color.black600)
            }
            // spacing: 20
            
            // 상세정보 버튼 (두개)
            HStack(spacing: 10){
                CapsuleButton(title: "상세정보", colorType: .border, isDisabled: false){
                    onAction(.detail)
                }
                CapsuleButton(title: "초대코드 복사", colorType: .fill, isDisabled: false){
                    onAction(.copyInviteCode(inviteCode: viewData.inviteCode))
                }
            }
            
        }
    }
}
