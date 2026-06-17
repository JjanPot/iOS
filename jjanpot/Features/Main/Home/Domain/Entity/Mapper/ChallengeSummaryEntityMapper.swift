//
//  ChallengeSummaryEntityMapper.swift
//  jjanpot
//
//  Created by 임주희 on 4/5/26.
//


struct ChallengeSummaryEntityMapper {
    func map(from dto: ChallengeSummaryDto) -> ChallengeSummaryEntity {
        ChallengeSummaryEntity(
            team: ChallengeSummaryEntity.Team(
                avgCertificationCount: dto.team.avgCertificationCount,
                participationRate: dto.team.participationRate,
                consecutiveDays: dto.team.consecutiveDays
            ),
            personal: ChallengeSummaryEntity.Personal(
                certificationCount: dto.personal.certificationCount,
                participationRate: dto.personal.participationRate,
                consecutiveDays: dto.personal.consecutiveDays
            )
        )
    }
}
