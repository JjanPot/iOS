//
//  ChallengeNoneView.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//

import Foundation
import SwiftUI

// MARK: 챌린지 없음 (여긴 하드코딩)
struct ChallengeNoneView : View {
    
    let onAction: (ChallengeCardAction) -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 28) {
            
            VStack(alignment: .leading, spacing: 8) {
                // 챌린지 상태
                
                BadgeView(title: "대기중인 챌린지 없음")
                
                // 팀이름
                Text("챌린지를 시작해보세요!")
                    .font(.pretendard(.semiBold, size: 26))
                    .foregroundStyle(Color.black900)
                
                // 부제
                Text("새로운 챌린지를 만들거나 초대를 받아보세요")
                    .font(.pretendard(.regular, size: 14))
                    .foregroundStyle(Color.black500)
            }
            // spacing: 28
            
            // 상세정보 버튼 (두개)
            HStack(spacing: 10){
                CapsuleButton(title: "챌린지 만들기", colorType: .border, isDisabled: false){
                    onAction(.createChallenge)
                }
                CapsuleButton(title: "초대코드 입력", colorType: .fill, isDisabled: false){
                    onAction(.inputInviteCode)
                }
            }
        }
        
    }
}
