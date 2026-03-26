//
//  ChallengeCard.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

enum ChallengeStatus {
    // 없음
    case none
    // 대기중
    case waiting(viewData: ChallengePendingViewData)
    // 챌린지 진행중
    case inProgress(viewData: ChallengeInProgressViewData)
}

// 챌린지 카드
struct ChallengeCardView: View {
    let status: ChallengeStatus
    // 버튼클릭 액션
    let onAction: (ChallengeCardAction) -> Void
    
    var body: some View {
        VStack {
            switch status {
            case .none:
                ChallengeNoneView(onAction: onAction)
            case let .waiting(viewData):
                ChallengePendingView(viewData: viewData, onAction: onAction)
            case let .inProgress(viewData):
                ChallengeInProgressView(viewData: viewData, onAction: onAction)
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 20)
        .background(Color.orange100)
        .rounded(radius: 12)
        .roundedBorder(color: .orange300, radius: 12)
        .fixedSize(horizontal: true, vertical: false)
    }
}

enum ChallengeCardAction {
    // 챌린지 만들기
    case createChallenge
    // 상세정보
    case detail
    // 초대코드입력
    case inputInviteCode
    // 초대코드 복사
    case copyInviteCode
    // 인증하기
    case submitSavingsProof
}








#Preview {
    ChallengeCardView(status: .none, onAction: {_ in})
    ChallengeCardView(status: .waiting(viewData: .init(teamName: "배달을 아껴요", targetSavingsAmount: 30, period: "26.07.15 - 16.07.21 (1주)")), onAction: {_ in})
    ChallengeCardView(status: .inProgress(viewData: .init(teamName: "배달좀아껴요", dday: 3, teamSavingsAmount: "250,000원", personalSavingsAmount: "25,000원")), onAction: {_ in})
}

