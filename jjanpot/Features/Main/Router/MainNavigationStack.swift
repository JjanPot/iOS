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
    @ObservedObject private var appCoordinator: AppCoordinator

    private let mainCoordinator: MainNavigationCoordinatorProtocol
    private let challengeCoordinator: ChallengeCoordinatorProtocol
    private let myPageCoordinator: MyPageCoordinatorProtocol

    private let container: MainDIContainerProtocol

    init(container: MainDIContainerProtocol, appCoordinator: AppCoordinator) {
        self.container = container
        self.appCoordinator = appCoordinator
        self.mainCoordinator = MainCoordinator(appCoordinator: appCoordinator)
        self.challengeCoordinator = container.makeChallengeCoordinator(appCoordinator: appCoordinator)
        self.myPageCoordinator = MyPageCoordinator(appCoordinator: appCoordinator)
    }

    var body: some View {
        NavigationStack(path: $appCoordinator.path) {

            // 메인 탭 화면
            MainTabView(
                homeView: AnyView(container.makeHomeView(coordinator: mainCoordinator)),
                challengeView: AnyView(container.makeChallengeDashboardView(coordinator: challengeCoordinator)),
                myPotView: AnyView(container.makeMyPotView(coordinator: myPageCoordinator))
            )
            // MARK: navigationDestination
            .navigationDestination(for: MainDestination.self) { destination in
                destinationView(for: destination)
            }
            // MARK: popup
            .popup(isPresented: Binding(
                get: { appCoordinator.activePopup != nil },
                set: { if !$0 { appCoordinator.closePopup()} }
            )) {
                popupContentView
            }
            // MARK: sheet
            .sheet(isPresented: Binding(get: {
                appCoordinator.activeSheet != nil
            }, set: {
                if !$0 {
                    appCoordinator.closeSheet()
                }
            }), onDismiss: {

            }, content: {
                sheetContentView
                    .presentationDetents(appCoordinator.activeSheet?.presentationDetents ?? [.medium])
                    .presentationDragIndicator(appCoordinator.activeSheet?.presentationDragIndicator ?? .automatic)
            })
            // MARK: fullScreenCover
            .fullScreenCover(isPresented: Binding(get: { appCoordinator.webViewUrl != nil},
                                                  set: { if !$0 { appCoordinator.webViewUrl = nil }

            })) {
                if let url = appCoordinator.webViewUrl {
                    container.makeWebView(url: url, onDismiss: {
                        appCoordinator.webViewUrl = nil
                    })
                }
            }
        }
    }
    
    // MARK: - destinationView

    @ViewBuilder
    private func destinationView(for destination: MainDestination) -> some View {
        switch destination {
            // 챌린지 생성
        case .createChallenge:
            container.makeCreateChallengeView(coordinator: challengeCoordinator)

            // 상세보기
        case let .challengeDetail(id):
            container.makeChallengeDetailView(challengeId: id, coordinator: challengeCoordinator)

            // 인증하기
        case let .challengePost(id):
            container.makeChallengePostView(challengeId: id, coordinator: challengeCoordinator)

            // 설정화면
        case .settings:
            container.makeSettingsView(coordinator: myPageCoordinator)

            // 알람 설정
        case .alarmSettings:
            container.makeAlarmSettingsView()

            // 챌린지 결과 화면
        case let .challengeReport(id):
            container.makeChallengeReportView(challengeId: id, coordinator: challengeCoordinator)

        case .challengeHistory:
            container.makeChallengeHistoryView(coordinator: myPageCoordinator)

            // 챌린지 인증 수정
        case let .challengeEditFeed(challengeId, entity):
            container.makeChallengeEditView(challengeId: challengeId, feedEntity: entity, coordinator: challengeCoordinator)
        }
    }
    
    // MARK: - popupContentView
    
    @ViewBuilder
    private var popupContentView: some View {
        switch appCoordinator.activePopup {
        case .inviteCode_Input: // 초대코드 팝업
            container.makeInviteCodePopupView(inviteCode: nil, onCloseAction: {
                appCoordinator.closePopup()
            })

        case let .inviteCode_Copy(inviteCode):
            container.makeInviteCodePopupView(inviteCode: inviteCode, onCloseAction: {
                appCoordinator.closePopup()
            })

        case let .reportPopup(challengeId):
            container.makeReportPopupView(challengeId: challengeId) {
                appCoordinator.closePopup()
                appCoordinator.push(.challengeReport(id: challengeId))
            } closeAction: {
                appCoordinator.closePopup()
            }

        case let .modal(modal):
            modal

        case .login:
            Modal(
                title: "로그인이 필요해요",
                content: "챌린지 생성 및 참여는 로그인 후 이용하실 수 있어요."
            ).buttons {
                ModalButton(title: "닫기", colorType: .secondary) {
                    appCoordinator.closePopup()
                }
                ModalButton(title: "로그인하기", size: .large) {
                    appCoordinator.closePopup()
                    // TODO: [임시] 로그아웃 (로그인 NavigationStack으로 전환)
                    NotificationCenter.default.post(name: NSNotification.Name("userDidLogout"), object: nil)
                }
            }


        case let .reportFeedReason(feedId, confirmAction):
            container.makeReportReasonSelectorPopupView(
                reason: ReportFeedReason.inappropriateBehavior,
                reportType: .feed(feedId: feedId),

                confirmAction: {
                    confirmAction?()
                    appCoordinator.closePopup()
                },
                closeAction: {
                    appCoordinator.closePopup()
                })

        case let .reportUserReason(userId, challengeId, confirmAction):
            container.makeReportReasonSelectorPopupView(
                reason: ReportUserReason.inappropriateBehavior,
                reportType: .user(userId: userId, challengeId: challengeId),
                confirmAction: {
                    confirmAction?()
                    appCoordinator.closePopup()
                },
                closeAction: {
                    appCoordinator.closePopup()
                })

        case .none:
            EmptyView()
        }
    }
    
    // MARK: - sheetContentView

    @ViewBuilder
    private var sheetContentView: some View {

        switch appCoordinator.activeSheet {
        case let .reportUser(reportUser, blockUser):
            container.makeReportUserSheet(onReportUser: reportUser, onBlockUser: blockUser, onCloseAction: {
                appCoordinator.closeSheet()
                
            })
                .background(Color.white)

        case .none:
            EmptyView()
        }
    }
    
    
}

#Preview {
    let container = MockMainDIContainer()
    let appCoordinator = AppCoordinator(container: container)
    return MainNavigationStack(container: container, appCoordinator: appCoordinator)
}
