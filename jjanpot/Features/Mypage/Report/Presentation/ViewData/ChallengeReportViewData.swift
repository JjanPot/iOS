//
//  ChallengeReportViewData.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//

import Foundation

struct ChallengeReportViewData {
    enum Result {
        case success
        case failed
        
        var title: String {
            switch self {
            case .success: return "목표 달성!"
            case .failed: return "목표 실패"
            }
        }
        var image: String {
            switch self {
            case .success: return "success"
            case .failed: return "failure"
            }
        }
    }
    
    let result: Result
    let message: String
    
    // 팀 절약 결과
    let teamSavingResult: TeamSavingResultViewData
    
    // 개인절약금액
    let personalSavingAmount: Int
    
    // 절약현황
    let summaryViewData: ChallengeSummaryViewData
    
    // 챌린지 기본 정보
    let basicInfo: ChallengeBasicInfoViewData
    
    
}
