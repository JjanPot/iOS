//
//  ChallengePendingViewData.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


// MARK: 챌린지 대기
struct ChallengeWaitingViewData {
    
    let challengeId: Int
    
    let teamName: String
    
    // 팀 목표금액 30만원
    let targetSavingsAmount: String
    
    // 기간 "26.07.15 - 16.07.21 (1주)"
    let period: String
    
    let inviteCode: String?
}
