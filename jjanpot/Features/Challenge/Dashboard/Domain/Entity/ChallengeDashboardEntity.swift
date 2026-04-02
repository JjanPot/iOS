//
//  ChallengeDashboardEntity.swift
//  jjanpot
//
//  Created by 임주희 on 4/2/26.
//

import Foundation

enum ChallengeDashboardEntity {
    // 없음
    case none
    // 대기중
    case waiting(id: Int)
    // 챌린지 진행중
    case inProgress(id: Int, overview: OverviewEntity, feeds: [FeedEntity])
}



