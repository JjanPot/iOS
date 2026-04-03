//
//  MainNavigationStack.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

/// 메인 플로우의 독립적인 NavigationStack
/// App 레벨에서 분기되어 메인 관련 화면들을 관리합니다.
struct MainNavigationStack: View {
    @StateObject private var coordinator: MainCoordinator
    @StateObject private var popupManager = PopupManager.shared

    private let container: MainDIContainerProtocol
    private let myPageContainer: MyPageDIContainerProtocol

    init(container: MainDIContainerProtocol, myPageContainer: MyPageDIContainerProtocol) {
        self.container = container
        self.myPageContainer = myPageContainer
        self._coordinator = StateObject(wrappedValue: container.makeMainCoordinator())
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {

            // 메인 탭 화면
            MainTabView(
                homeView: AnyView(container.makeHomeView(coordinator: coordinator)),
                challengeView: AnyView(container.makeChallengeDashboardView(coordinator: coordinator)),
                myPotView: AnyView(MyPageNavigationStack(container: myPageContainer))
            )
            .navigationDestination(for: MainDestination.self) { destination in
                destinationView(for: destination)
            }
            .popup(isPresented: $popupManager.showInviteCodePopup, onDismiss: {
                popupManager.inviteCode = nil
            }) {
                // 초대코드 팝업
                container.makeInviteCodePopupView(inviteCode: popupManager.inviteCode, onCloseAction: {
                    popupManager.dismiss()
                })
            }
        }
    }

    @ViewBuilder
    private func destinationView(for destination: MainDestination) -> some View {
        switch destination {
        case .createChallenge:
            container.makeCreateChallengeView(coordinator: coordinator)

        case let .challengeDetail(id):
            container.makeChallengeDetailView(challengeId: id, coordinator: coordinator)
            
        case let .challengePost(id):
            container.makeChallengePostView(challengeId: id, coordinator: coordinator)
        }
    }
   
}

#Preview {
    MainNavigationStack(container: MockMainDIContainer(), myPageContainer: MockMyPageDIContainer())
}
