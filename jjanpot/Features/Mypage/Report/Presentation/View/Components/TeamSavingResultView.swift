//
//  TeamSavingResult.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//

import SwiftUI


// 결과 리포트 > 팀 결과
struct TeamSavingResultView: View {
    let viewData: TeamSavingResultViewData
    var body: some View {
        VStack(alignment: .center, spacing: .zero) {
            Text("\(viewData.teamName) 팀 절약 결과")
                .font(.pretendard(.semiBold, size: 16))
                .foregroundStyle(.orange900)
                .padding(.bottom, 7)
            
            HStack(alignment: .bottom, spacing: 8) {
                Text("\(viewData.amount)")
                    .font(.pretendard(.bold, size: 56))
                    .foregroundStyle(.orange600)
                Text("원")
                    .padding(.bottom, 10)
                    .font(.pretendard(.semiBold, size: 16))
                    .foregroundStyle(Color.orange900)
            }
            .padding(.bottom, 16)
            
            Text(viewData.summaryMessage)
                .font(.pretendard(.semiBold, size: 16))
                .foregroundStyle(.orange600)
//                .padding(.bottom, 20)
            
            /*
            VStack(alignment: .center, spacing: 10){
                Text("이 금액으로 살 수 있어요")
                    .font(.pretendard(.medium,size: 20))
                    .foregroundStyle(Color.black700)
                
                Text(viewData.rewardMessage)
                    .font(.pretendard(.semiBold, size: 24))
                    .foregroundStyle(Color.orange500)
            }
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity, alignment: .center)
            .background(Color.white)
            .rounded(radius: 12)
            */
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(
            LinearGradient(
                colors: [.white, .orange200],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        )
        .rounded(radius: 20)
        .roundedBorder(color: .orange400, radius: 20)

    }
}

#Preview {
    TeamSavingResultView(viewData: TeamSavingResultViewData(
        teamName: "배달을 아껴요",
        amount: 297_000,
        summaryMessage: "목표 300,000원 달성🎉 총104%",
        rewardMessage: "🎧 에어팟 + 치킨 1마리 🍗"
    ))
}
