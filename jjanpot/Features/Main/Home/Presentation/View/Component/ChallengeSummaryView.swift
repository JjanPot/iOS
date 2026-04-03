//
//  SavingsSummaryView.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//

import SwiftUI


// 챌린지 절약 현황 (팀, 개인)
struct ChallengeSummaryView: View {
    let viewData: ChallengeSummaryViewData
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Text("팀 절약 현황")
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundStyle(.black900)
                
                // 인증평균, 참여율, 연속활동
                HStack(spacing: 5) {
                    SavingsSummaryCard(type: .averageProof, value: viewData.team.certificationCount)
                    Spacer()
                    SavingsSummaryCard(type: .participationRate, value: viewData.team.participationRate)
                    Spacer()
                    SavingsSummaryCard(type: .consecutiveActivity, value: viewData.team.consecutiveDays)
                }
            }
            
            
            VStack(alignment: .leading, spacing: 10) {
                Text("개인 절약 현황")
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundStyle(.black900)
                
                // 인증횟수, 참여율, 연속활동
                HStack(spacing: 5) {
                    SavingsSummaryCard(type: .proofCount, value: viewData.personal.consecutiveDays)
                    Spacer()
                    SavingsSummaryCard(type: .participationRate, value: viewData.personal.participationRate)
                    Spacer()
                    SavingsSummaryCard(type: .consecutiveActivity, value: viewData.personal.consecutiveDays)
                }
            }
        }
        
    }
}

#Preview {
    ChallengeSummaryView(viewData: .init(
        team: .init(
            certificationCount: "10",
            participationRate: "7.8",
            consecutiveDays: "2"
        ),
        personal: .init(
            certificationCount: "3",
            participationRate: "90",
            consecutiveDays: "4"
        )))
    
}
