//
//  HomeView.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    private let container: MainDIContainerProtocol
    
    init(viewModel: HomeViewModel, container: MainDIContainerProtocol) {
        self._viewModel = StateObject(wrappedValue: viewModel)
        self.container = container
    }

    @State private var showInvitePopup: Bool = false
    @State private var tempInviteCode: String?

    var body: some View {
        VStack(spacing: .zero) {
            // 헤더
            HStack {
                Image("TextLogo")
                    .resizable()
                    .frame(width: 122, height: 18.49)
                Spacer()

                // TODO: 알람버튼
            }
            .padding(20)

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
            }
        } // ~VStack
        .onAppear {
            viewModel.loadHomeData()
        }
        .loading(viewModel.isLoading)
        .toast(message: $viewModel.toastMessage)
        .popup(isPresented: $showInvitePopup, dismissOnBackgroundTap: true ,onDismiss: {
            tempInviteCode = nil
        }) {
            container.makeInviteCodePopupView(inviteCode: tempInviteCode, onCloseAction: {
                showInvitePopup = false
            })
        }
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
            print(">>>>> createChallenge")
        case .detail:
            print(">>>>> detail")
            
        case .inputInviteCode:
            tempInviteCode = nil //초대코드 없음. 받아야해
            showInvitePopup = true

        case let .copyInviteCode(code):
            tempInviteCode = code
            showInvitePopup = true

        case .submitSavingsProof:
            print(">>>>> submitSavingsProof")
        }
    }
}

#Preview {
    MockMainDIContainer().makeHomeView()
}
