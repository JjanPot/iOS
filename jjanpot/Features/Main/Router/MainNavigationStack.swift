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

    private let container: MainDIContainerProtocol

    init(container: MainDIContainerProtocol) {
        self.container = container
        self._coordinator = StateObject(wrappedValue: container.makeMainCoordinator())
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {

            // 메인 탭 화면
            MainTabView(
                homeView: AnyView(container.makeHomeView(coordinator: coordinator)),
                challengeView: AnyView(container.makeChallengeDashboardView(coordinator: coordinator)),
                myPotView: AnyView(container.makeMyPotView(coordinator: coordinator))
            )
            .navigationDestination(for: MainDestination.self) { destination in
                destinationView(for: destination)
            }
            .popup(isPresented: Binding(
                get: { coordinator.activePopup != nil },
                set: { if !$0 { coordinator.activePopup = nil } }
            )) {
                popupContentView
            }
        }
    }

    @ViewBuilder
    private func destinationView(for destination: MainDestination) -> some View {
        switch destination {
            // 챌린지 생성
        case .createChallenge:
            container.makeCreateChallengeView(coordinator: coordinator)

            // 상세보기
        case let .challengeDetail(id):
            container.makeChallengeDetailView(challengeId: id, coordinator: coordinator)
            
            // 인증하기
        case let .challengePost(id):
            container.makeChallengePostView(challengeId: id, coordinator: coordinator)
            
            // 설정화면
        case .settings:
            container.makeSettingsView(coordinator: coordinator)
            
            // 알람 설정
        case .alarmSettings:
            container.makeAlarmSettingsView()
            
            // 챌린지 결과 화면
        case let .challengeReport(id):
            container.makeChallengeReportView(challengeId: id, coordinator: coordinator)
            
        case .challengeHistory:
            container.makeChallengeHistoryView(coordinator: coordinator)
        }
    }
    
    @ViewBuilder
    private var popupContentView: some View {
        switch coordinator.activePopup {
        case .inviteCode_Input: // 초대코드 팝업
            container.makeInviteCodePopupView(inviteCode: nil, onCloseAction: {
                coordinator.activePopup = nil
            })
            
        case let .inviteCode_Copy(inviteCode):
            container.makeInviteCodePopupView(inviteCode: inviteCode, onCloseAction: {
                coordinator.activePopup = nil
            })
            
        case .none:
            EmptyView()
        }
    }
}

#Preview {
    MainNavigationStack(container: MockMainDIContainer())
}
