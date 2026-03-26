//
//  CurrentChallengeEntity.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import Foundation

struct CurrentChallengeEntity {
    enum ChallengeStatus {
        case none
        case waiting(entity: ChallengeWaitingEntity)
        case inProgress(entity: ChallengeInProgressEntity)
        
        static func == (lhs: ChallengeStatus, rhs: ChallengeStatus) -> Bool {
            switch (lhs, rhs) {
            case (.none, .none): return true
            case (.waiting, .waiting): return true
            case (.inProgress, .inProgress): return true
            default: return false
            }
        }
    }
    
    
    // 진행상태
    let status: ChallengeStatus
}

// MARK: 대기중
struct ChallengeWaitingEntity {
    let challengeId: Int
    let title: String
    
    // 목표금액 (300000 통으로 내려옴) 
    let goalAmount: Int
    
    // 시작일
    let startDate: Date
    
    // 종료일
    let endDate: Date
    
    // 리더인지 여부
    let isLeader: Bool
    
    // 초대코드
    let inviteCode: String
}

// MARK: 진행중
struct ChallengeInProgressEntity {
    let challengeId: Int
    let title: String
    
    // 종료일
    let endDate: Date
    
    // 몇주인지??
    let weekNumber: Int
    
    // 목표금액
    let weekGoalAmount: Int
    
    // 팀절약금액
    let teamWeekSavedAmount: Int
    
    // 개인절약금액
    let personalWeekSavedAmount: Int
    
    // 성취도
    let achievementRate: Int
}
