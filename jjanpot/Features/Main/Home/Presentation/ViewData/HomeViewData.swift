//
//  HomeViewData.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import Foundation

/// 홈 화면 뷰 데이터
struct HomeViewData {
    let teamMessage: String
    let challenge: ChallengeViewData?
    let summary: ChallengeSummaryViewData?

    /// 챌린지 상태별 뷰 데이터
    enum ChallengeViewData {
        case none
        case pending(ChallengePendingViewData)
        case inProgress(ChallengeInProgressViewData)
    }
}
