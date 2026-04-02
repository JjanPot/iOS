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
                    switch viewModel.viewData {
                    
                    case let .inProgress(_, _, feeds):
                        ForEach(feeds) { feed in
                            switch feed {
                            case let .header(_, date):
                                FeedHeaderView(title: date)
                            case let .item(_, feed):
                                FeedCardView(viewData: feed)
                                
                            case .bottom:
                                Spacer()
                                    .frame(height: 100)
                            }
                        }
                        
                    default: Spacer()
                    }
                    
                    
                    
                    
                    
                    
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
