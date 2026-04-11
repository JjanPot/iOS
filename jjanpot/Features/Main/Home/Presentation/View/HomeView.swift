//
//  HomeView.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject private var authManager = AuthManager.shared
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
                    HStack {
                        // 메세지박스
                        Text(viewModel.homeViewData?.teamMessage ?? "")
                            .font(.pretendard(.medium, size: 20))
                            .foregroundStyle(.black900)
                        
                        Spacer()
                        
                        Image("charater")
                            .resizable()
                            .frame(width: 76.73, height: 72)
                    }
                    
                    // 챌린지 카드
                    if let viewData = viewModel.homeViewData?.challengeCard {
                        ChallengeCardView(
                            status: mapToChallengeCardStatus(viewData),
                            onAction: handleChallengeCardAction
                        )
                    } else {
                        ChallengeCardView(
                            status: .none,
                            onAction: handleChallengeCardAction
                        )
                    }
                    
                    // 챌린지 절약 현황
                    if let summary = viewModel.homeViewData?.summary {
                        ChallengeSummaryView(viewData: summary)
                    }
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 50)
            }
        } // ~VStack
        .task {
            viewModel.requestAuthorization()
            viewModel.loadHomeData()
            viewModel.loadHistories()
        }
        .onChange(of: viewModel.showReportPopup) { showReportPopup in
            if showReportPopup, let id = viewModel.completeChallengeId {
                coordinator.activePopup = .reportPopup(challengeId: id)
            }
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
            guard authManager.isLoggedIn else {
                coordinator.activePopup = .login
                return
            }
            
            coordinator.push(.createChallenge)
        case let .detail(id):
            coordinator.push(.challengeDetail(id: id))

        case .inputInviteCode: // 초대코드 입력
            guard authManager.isLoggedIn else {
                coordinator.activePopup = .login
                return
            }
            
            coordinator.activePopup = .inviteCode_Input

        case let .copyInviteCode(code):
            guard let code else { return }
            coordinator.activePopup = .inviteCode_Copy(inviteCode: code)

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
