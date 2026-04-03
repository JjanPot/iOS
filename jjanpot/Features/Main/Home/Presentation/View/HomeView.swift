//
//  HomeView.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @ObservedObject var coordinator: MainCoordinator

    init(viewModel: HomeViewModel, coordinator: MainCoordinator) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.coordinator = coordinator
    }

    var body: some View {
        VStack(spacing: .zero) {
            // 헤더
            MainHeader()

            // 내용물
            ScrollView {
                VStack(spacing: 20) {
                    if let homeViewData = viewModel.homeViewData {
                        HStack {
                            // 메세지박스
                            Text(homeViewData.teamMessage)
                                .font(.pretendard(.medium, size: 20))
                                .foregroundStyle(.black900)
                                
                            Spacer()
                            
                            Image("charater")
                                .resizable()
                                .frame(width: 76.73, height: 72)
                        }
                        
                        // 챌린지 카드
                        ChallengeCardView(
                            status: mapToChallengeCardStatus(homeViewData.challengeCard),
                            onAction: handleChallengeCardAction
                        )
                        
                        // 챌린지 절약 현황
                        if let summary = homeViewData.summary {
                            ChallengeSummaryView(viewData: summary)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
            }
        } // ~VStack
        .onAppear {
            viewModel.requestAuthorization()
            
            viewModel.loadHomeData()
        }
        .onReceive(NotificationCenter.default.publisher(for: .shouldRefreshMain), perform: { _ in
            viewModel.loadHomeData()
        })
        .loading(viewModel.isLoading)
        .toast(message: $viewModel.toastMessage)
    }

    // MARK: - Private Methods

    private func mapToChallengeCardStatus(_ challenge: ChallengeCardStatus?) -> ChallengeCardStatus {
        guard let challenge = challenge else {
            return .none
        }

        switch challenge {
        case .none:
            return .none
        case .waiting(let viewData):
            return .waiting(viewData: viewData)
        case .inProgress(let viewData):
            return .inProgress(viewData: viewData)
        }
    }

    private func handleChallengeCardAction(_ action: ChallengeCardAction) {
        switch action {
        case .createChallenge:
            coordinator.push(.createChallenge)
        case let .detail(id):
            coordinator.push(.challengeDetail(id: id))

        case .inputInviteCode:
            PopupManager.shared.showInviteCodeInput()

        case let .copyInviteCode(code):
            PopupManager.shared.showInviteCodeCopy(code: code)

        case let .submitSavingsProof(id):
            coordinator.push(.challengePost(id: id))
        }
    }
}

#Preview {
    let container = MockMainDIContainer()
    let coordinator = container.makeMainCoordinator()
    return container.makeHomeView(coordinator: coordinator)
}
