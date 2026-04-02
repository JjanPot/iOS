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
        ZStack {
            VStack {
                Color.orange50
                    .ignoresSafeArea(edges: .top)
                    .frame(height: 300)
                Color.clear
            }
            
            ScrollView {
                VStack (alignment: .leading, spacing: .zero){
                    
                    // MARK: 오버뷰 //
                    VStack (alignment: .center, spacing: .zero){
                        
                        HStack {
                            Spacer()
                        }
                        .frame(height: 30)
                        
                        
                        ChallengeOverview(viewData: viewModel.viewData)
                    }
                    .background(Color.orange50)
                    
                    // MARK: 피드 //
                    VStack (alignment: .leading, spacing: 12){
                        
                        HStack() {
                            Spacer()
                            Text("모든 게시글")
                                .font(.pretendard(.medium, size: 14))
                                .foregroundStyle(.black500)
                                .padding(.top, 24)
                            Spacer()
                        }
                        .padding(.bottom, 12)
                        
                        // 게시물 목록 //
                        switch viewModel.viewData {
                        case let .inProgress(_, _, feeds):
                            Group {
                                ForEach(feeds) { feed in
                                    switch feed {
                                    case let .header(_, date):
                                        FeedHeaderView(title: date)
                                    case let .item(_, feed):
                                        FeedCardView(viewData: feed)
                                        
                                    case .bottom:
                                        Spacer()
                                            .frame(height: 28)
                                    }
                                }
                            }.padding(.horizontal, 20)
                            
                        default: // 피드 없을
                            Spacer()
                        }
                        
                        Spacer()
                            .frame(height: 100)
                        
                        
                    }
                    .background(Color.white)
                    
                }
            } // ScrollView
            
        } //Zstack
        .loading(viewModel.isLoading)
        .toast(message: $viewModel.toastMessage)
        .task {
            viewModel.loadChallengeDashboard()
        }
    }
}

#Preview {
    let di = MockMainDIContainer()
    di.makeChallengeDashboardView(coordinator: di.makeMainCoordinator())
}
