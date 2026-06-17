//
//  ChallengeCardStatus.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//

// challengeCard ViewData
enum ChallengeCardStatus {
    // 없음
    case none
    // 대기중
    case waiting(viewData: ChallengeWaitingViewData)
    // 챌린지 진행중
    case inProgress(viewData: ChallengeInProgressViewData)
}


