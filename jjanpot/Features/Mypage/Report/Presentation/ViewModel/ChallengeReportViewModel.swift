//
//  ChallengeReportViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//


import SwiftUI
import Combine


final class ChallengeReportViewModel: ObservableObject {
    
    @Published var viewData: ChallengeReportViewData? = ChallengeReportViewData(
        result: .failed,
        message: "완벽한 팀워크, 완벽한 절약!\n함께라서 더 빛나는 결과예요.",
        teamSavingResult: TeamSavingResultViewData(
            teamName: "배달을 아껴요",
            amount: 297_000,
            summaryMessage: "목표 300,000원 달성🎉 총104%",
            rewardMessage: "🎧 에어팟 + 치킨 1마리 🍗"
        ),
        personalSavingAmount: 25_000,
        summaryViewData: ChallengeSummaryViewData(team: ChallengeSummaryViewData.SavingsSummaryViewData(
            certificationCount: "3.0",
            participationRate: "100",
            consecutiveDays: "1"),
                                                  personal: ChallengeSummaryViewData.SavingsSummaryViewData(certificationCount: "0", participationRate: "33", consecutiveDays: "0")),
        basicInfo: ChallengeBasicInfoViewData(
            teamName: "배달을 아껴요",
            goals: "30만원 목표로 1주 함께 절약하기",
            category: "외식/배달",
            teamTargetAmount: "30만원",
            personTargetAmound: "2만원 이상",
            relationshipType: "친구",
            during: "26.07.15 - 16.07.21(1주)",
            memberCount: "5명"
        )
    )
    
    @Published var isLoading = false
       @Published var toastMessage: String?
    
    
    private let useCase: ChallengeReportUseCaseProtocol
    init(useCase: ChallengeReportUseCaseProtocol) {
        self.useCase = useCase
    }
}
