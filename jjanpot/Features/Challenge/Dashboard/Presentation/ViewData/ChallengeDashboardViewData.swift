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
    
    var challengeId: Int? {
        switch self {
        case .noneChallenge: return nil
        case .waiting: return nil
        case let .inProgress(challengeId, _, _): return challengeId
        }
    }
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

enum ChallengeFeedViewData: Identifiable {
    case header(id: UUID, date: String)
    case item(id: UUID, feed: FeedCardViewData)
    case bottom(id: UUID)
    
    var id: UUID {
            switch self {
            case let .header(id, _):
                return id
            case let .item(id, _):
                return id
            case let .bottom(id):
                return id
            }
        }
}


