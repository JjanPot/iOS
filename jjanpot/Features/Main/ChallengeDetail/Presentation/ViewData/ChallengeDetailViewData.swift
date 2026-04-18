//
//  ChallengeDetailViewData.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


struct ChallengeDetailViewData {
    let status: ChallengeStatus
    let basicInfo: ChallengeBasicInfoViewData
    
    // 챌린지 설명
    let description: String
    let hasCancelButton: Bool
    
    
    enum ChallengeStatus {
        /// 없음
        case none
        
        /// 대기중
        case waiting
        
        /// 챌린지 진행중
        case inProgress
    }
}

struct ChallengeBasicInfoViewData {
    let status: ChallengeStatus
    let teamName: String
    let goals: String
    let category: String
    let teamTargetAmount: String
    let personTargetAmound: String
    let relationshipType: String
    let during: String
    let memberCount: String
}
