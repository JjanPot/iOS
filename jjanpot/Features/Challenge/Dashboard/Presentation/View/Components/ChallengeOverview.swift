//
//  ChallengeOverview.swift
//  jjanpot
//
//  Created by 임주희 on 4/2/26.
//

import SwiftUI

struct ChallengeOverview: View {
    let viewData: ChallengeDashboardViewData?
    
    var body: some View {
        switch viewData {
        case .noneChallenge:
            emptyOverview(
                message: "아직 챌린지가 없어요"
            )
        case .waiting:
            emptyOverview(
                message: "챌린지 시작을 기다리고 있어요."
            )
        case let .inProgress(_, overviewViewData, _):
            overview(overviewViewData)
            
        default:
            emptyOverview(
                message: "LOADING..."
            )
        }
    }
    
    private func overview(_ viewData: ChallengeOverviewViewData) -> some View {
        VStack (alignment: .center, spacing: .zero){
            
            Text(viewData.title)
                .font(.pretendard(.semiBold, size: 24))
                .foregroundStyle(.black)
                .padding(.bottom, 20)
            
            Text(viewData.description)
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(.black700)
                .padding(.bottom, 15)
            
            HStack (alignment: .bottom, spacing: .zero){
                Text("\(viewData.totalSavedAmount)원")
                    .font(.pretendard(.semiBold, size: 30))
                    .foregroundStyle(.black)
                    .frame(minWidth: 100, alignment: .trailing)
                Text("/ \(viewData.goalAmount)원")
                    .font(.pretendard(.medium, size: 16))
                    .foregroundStyle(.black500)
            }
            
            SegmentedBar(segments: viewData.segments)
            .padding(.vertical, 16)
            
            
            // 유저 목록
            MemberPagerView(members: viewData.members)
            
        }
        .padding([.horizontal, .bottom],20)
    }
    
    
    private func emptyOverview(message: String) -> some View {
        VStack (alignment: .center, spacing: 15){
            Image("nodata")
                .resizable()
                .frame(width: 124, height: 124)
                
            Text(message)
                .font(.pretendard(.medium, size: 14))
                .foregroundStyle(.black500)
                .padding(.vertical, 8)
                .padding(.horizontal, 11)
                .background(Color.white)
                .clipShape(Capsule())
        }
        .padding(.vertical, 50)
    }

}

#Preview {
    ChallengeOverview(viewData:
            .inProgress(challengeId: 0,
                        overviewViewData: ChallengeOverviewViewData(
                            title: "카페는 이제 그만!",
                            description: "7월 15일부터 현재까지 절약 금액",
                            totalSavedAmount: 206100,
                            goalAmount: 300000,
                            segments: [
                                .init(ratio: 0.2, color: .red),
                                .init(ratio: 0.25, color: .orange),
                                .init(ratio: 0.15, color: .yellow),
                                .init(ratio: 0.3, color: .brown),
                                .init(ratio: 0.1, color: .black)
                            ],
                            members: [
                                .init(userId: 0, nickname: "닉네임0", imageUrl: "", color: .red, amount: 10000, isLeader: true, isBlocked: false),
                                .init(userId: 0, nickname: "닉네임2닉에임", imageUrl: "", color: .black, amount: 12000, isLeader: false, isBlocked: false),
                                .init(userId: 0, nickname: "닉네임3", imageUrl: "", color: .blue, amount: 13000, isLeader: false, isBlocked: false),
                                .init(userId: 0, nickname: "닉네임4", imageUrl: "", color: .green, amount: 14000, isLeader: false, isBlocked: false),
                                     ]
                        ),
                        feedViewData: []
                       ))
}
