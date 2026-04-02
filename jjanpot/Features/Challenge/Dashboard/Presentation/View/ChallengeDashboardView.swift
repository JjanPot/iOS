//
//  ChallengeDashboardView.swift
//  jjanpot
//
//  Created by 임주희 on 3/29/26.
//

import SwiftUI

// 챌린지 대시보드
struct ChallengeDashboardView: View {
    @StateObject var viewModel: ChallengeDashboardViewModel
    private let coordinator: MainCoordinator
    

    init(viewModel: ChallengeDashboardViewModel, coordinator: MainCoordinator) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: .zero){
            VStack (alignment: .center, spacing: .zero){
                MainHeader()
                
                // MARK: 오버뷰 //
                
                ChallengeOverview(viewData: viewModel.viewData)
                
                
            }
            .background(Color.orange50)
            
            // MARK: 피드 //
            ScrollView {
                VStack (alignment: .leading, spacing: .zero){
                    
                    HStack() {
                        Spacer()
                        Text("모든 게시글")
                            .font(.pretendard(.medium, size: 14))
                            .foregroundStyle(.black500)
                            .padding(.top, 24)
                        Spacer()
                    }
                    .padding(.bottom, 24)
                    
                    // 게시물 목록 //
                    FeedHeaderView()
                    FeedCardView(viewData: FeedCardViewData(
                        category: "카페/디저트",
                        title: "오므라이스 최고",
                        content: "텀블러에 담아서 먹었는데 그럭저럭 먹을만하더라구요. 다들 맛있게 절약하세요.",
                        price: "+3,500원",
                        likeCount: 3,
                        date: "2027.09.18 18:30"
                    ))
                    
                }
                .padding(.horizontal, 20)
            }
        }
        .task {
            viewModel.loadChallengeDashboard()
        }
    }
}

#Preview {
    let di = MockMainDIContainer()
    di.makeChallengeDashboardView(coordinator: di.makeMainCoordinator())
}
