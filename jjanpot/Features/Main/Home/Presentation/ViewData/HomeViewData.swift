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
    let challengeCard: ChallengeCardStatus
    let summary: ChallengeSummaryViewData?
}

struct HomeViewDataMapper {
    func map(from entity: HomeEntity) -> HomeViewData {
        let cardViewData = challengeCardViewData(from: entity.challenge)
        let summaryViewData = summaryViewData(from: entity.summary)
        return HomeViewData(
            teamMessage: teamMessage(status: entity.challenge.status),
            challengeCard: cardViewData,
            summary: summaryViewData
        )
    }
    
    
    func teamMessage(status: CurrentChallengeEntity.ChallengeStatus) -> String {
        switch status {
        case .none: return "목표를 만들고 팀과 함께 절약해요!"
        case .waiting: return "계획은 완벽해요!\n시작 날짜를 기다리고 있어요."
        case .inProgress: return "무슨 메세지를 보여줄라나."
        }
    }
    
    // 챌린지 카드
    func challengeCardViewData(from entity: CurrentChallengeEntity )-> ChallengeCardStatus {
        ChallengeCardViewDataMapper().map(from: entity)
    }
    
    // 챌린지 절약현황
    func summaryViewData(from entity: ChallengeSummaryEntity?) -> ChallengeSummaryViewData? {
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
