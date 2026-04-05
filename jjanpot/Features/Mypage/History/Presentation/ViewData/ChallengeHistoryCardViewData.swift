//
//  ChallengeHistoryCardViewData.swift
//  jjanpot
//
//  Created by 임주희 on 4/5/26.
//

import Foundation
import SwiftUI

struct ChallengeHistoryCardViewData: Identifiable {
    let challengeId: Int
    let statusDisplayName: String
    let teamName: String
    let period: String
    
    var id: Int {
        challengeId
    }
}


struct ChallengeHistoryCardViewDataMapper {
    
    func map(from entity: HistoryEntity) -> ChallengeHistoryCardViewData {
        
        let period = period(start: entity.startDate, end: entity.endDate)
        return ChallengeHistoryCardViewData(
            challengeId: entity.challengeId,
            statusDisplayName: entity.statusDisplayName,
            teamName: entity.title,
            period: period
        )
    }
    // 시작일 - 종료일 (1주), ex: "26.07.15 - 26.07.21 (1주)"
    private func period(start :Date, end: Date) -> String {
        "\(start.toString(.simpleDateOnly)) - \(end.toString(.simpleDateOnly)) (1주)"
    }
}
