//
//  ChallengeDashboardViewData.swift
//  jjanpot
//
//  Created by 임주희 on 4/2/26.
//


import Foundation

enum ChallengeDashboardViewData {
    // 없음
    case noneChallenge
    // 대기중
    case waiting
    // 챌린지 진행중
    case inProgress(challengeId: Int,
                    overviewViewData: ChallengeOverviewViewData,
                    feedViewData: [ChallengeFeedViewData]
    )
}

struct ChallengeOverviewViewData {
    let title: String

    // "7월 15일부터 현재까지 절약금액"
    let description: String
    
    let totalSavedAmount, goalAmount: Int
    
    let segments: [SegmentedBarViewData]
    
    // let startDate: Date
    let members: [MemberCardViewData]
}

enum ChallengeFeedViewData {
    case header(date: String)
    case item(feed: FeedCardViewData)
    case bottom
}
