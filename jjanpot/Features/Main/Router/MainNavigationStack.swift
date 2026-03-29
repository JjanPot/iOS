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
    @StateObject private var coordinator = MainCoordinator()
    @StateObject private var popupManager = PopupManager.shared

    private let container: MainDIContainerProtocol

    init(container: MainDIContainerProtocol) {
        self.container = container
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {

            // 메인 탭 화면
            MainTabView(
                homeView: AnyView(container.makeHomeView(coordinator: coordinator)),
                challengeView: AnyView(ContentView()),
                myPotView: AnyView(ContentView2())
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
            container.makeCreateChallengeView()
            
        case .challengeDetail:
            container.makeChallengeDetailView()
        }
    }
}

#Preview {
    MainNavigationStack(container: MockMainDIContainer())
}
