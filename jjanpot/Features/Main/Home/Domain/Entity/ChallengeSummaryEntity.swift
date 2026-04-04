//
//  ChallengeSummaryEntity.swift
//  jjanpot
//
//  Created by 임주희 on 4/5/26.
//

import Foundation

struct ChallengeSummaryEntity {
    let team: Team
    let personal: Personal
    

    struct Team {
        let avgCertificationCount: Double
        // 참여율
        let participationRate: Int
        // 연속활동
        let consecutiveDays: Int
    }
    
    struct Personal {
        // 인증횟수
        let certificationCount: Int
        // 참여율
        let participationRate: Int
        // 연속활동
        let consecutiveDays: Int
    }
}

struct ChallengeSummaryViewDataMapper {
    func map(from entity: ChallengeSummaryEntity?) -> ChallengeSummaryViewData? {
        guard let entity else { return nil }
        let teamAvgCount = String(format: "%.1f", entity.team.avgCertificationCount)
        
        return ChallengeSummaryViewData(
            team: ChallengeSummaryViewData.SavingsSummaryViewData(
                certificationCount: teamAvgCount, // 인증평균
                participationRate: "\(entity.team.participationRate)", // 참여율
                consecutiveDays: "\(entity.team.consecutiveDays)"), // 연속활동
            personal: ChallengeSummaryViewData.SavingsSummaryViewData(
                certificationCount: "\(entity.personal.certificationCount)", // 인증횟수
                participationRate: "\(entity.personal.participationRate)", // 참여율
                consecutiveDays: "\(entity.personal.consecutiveDays)" // 연속활동
            ))
    }
}
