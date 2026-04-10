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
    
    @State var selectedFeedIdForMenu: Int?
    
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
                                        FeedCardView(viewData: feed,
                                                     isMenuOpen: Binding(
                                                        get: { selectedFeedIdForMenu == feed.feedId },
                                                        set: { isOpen in
                                                            if isOpen {
                                                                selectFeedForMenu(id: feed.feedId)
                                                            } else {
                                                                closeMenu()
                                                            }
                                                        })
                                        )

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

                    }
                    .background(Color.white)

                }
            } // ScrollView
            .simultaneousGesture(
                DragGesture(minimumDistance: 1)
                    .onChanged { _ in
                        closeMenu()
                    }
            )
            .onTapGesture {
                closeMenu()
            }
            
        } //Zstack
        .loading(viewModel.isLoading)
        .toast(message: $viewModel.toastMessage)
        .task {
            viewModel.loadChallengeDashboard()
        }
    }
    
    /// 메뉴 열기/닫기
    func selectFeedForMenu(id: Int) {
        selectedFeedIdForMenu = id
    }

    /// 메뉴 닫기
    private func closeMenu() {
        if selectedFeedIdForMenu != nil {
            selectedFeedIdForMenu = nil
        }
    }
}

#Preview {
    let di = MockMainDIContainer()
    di.makeChallengeDashboardView(coordinator: di.makeMainCoordinator())
}
