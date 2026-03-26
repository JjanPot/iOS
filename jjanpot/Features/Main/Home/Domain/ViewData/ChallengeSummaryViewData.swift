//
//  ChallengeSummaryViewData.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


// 챌린지 절약 현황 (팀, 개인)
struct ChallengeSummaryViewData {
    let team: SavingsSummaryViewData
    let personal: SavingsSummaryViewData
    
    
    // 개별 요약 데이터 (팀/개인 동일 구조)
    struct SavingsSummaryViewData {
        let certificationCount: String   // 인증횟수
        let participationRate: String    // 참여율
        let consecutiveDays: String         // 연속활동일
    }
}