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
            .sheet(isPresented: Binding(get: {
                coordinator.activeSheet != nil
            }, set: {
                if !$0 { coordinator.activeSheet = nil}
            }), onDismiss: {
                
            }, content: {
                sheetContentView
                    .presentationDetents(coordinator.activeSheet?.presentationDetents ?? [.medium])
                    .presentationDragIndicator(coordinator.activeSheet?.presentationDragIndicator ?? .automatic)
            })
            .fullScreenCover(isPresented: Binding(get: { coordinator.webViewUrl != nil},
                                                  set: { if !$0 { coordinator.webViewUrl = nil }
                
            })) {
                if let url = coordinator.webViewUrl {
                    container.makeWebView(url: url, onDismiss: {
                        coordinator.webViewUrl = nil
                    })
                }
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
            
            // 챌린지 인증 수정
        case let .challengeEditFeed(entity):
            container.makemakeChallengeEditView(feedEntity: entity, coordinator: coordinator)
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

        case let .reportPopup(challengeId):
            container.makeReportPopupView(challengeId: challengeId) {
                coordinator.activePopup = nil
                coordinator.push(.challengeReport(id: challengeId))
            } closeAction: {
                coordinator.activePopup = nil
            }

        case let .modal(modal):
            modal
            
        case .login:
            Modal(
                title: "로그인이 필요해요",
                content: "챌린지 생성 및 참여는 로그인 후 이용하실 수 있어요."
            ).buttons {
                ModalButton(title: "닫기", colorType: .secondary) {
                    coordinator.activePopup = nil
                }
                ModalButton(title: "로그인하기", size: .large) {
                    coordinator.activePopup = nil
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
                    coordinator.activePopup = nil
                },
                closeAction: {
                    coordinator.activePopup = nil
                })
            
        case let .reportUserReason(userId, challengeId, confirmAction):
            container.makeReportReasonSelectorPopupView(
                reason: ReportUserReason.inappropriateBehavior,
                reportType: .user(userId: userId, challengeId: challengeId),
                confirmAction: {
                    confirmAction?()
                    coordinator.activePopup = nil
                },
                closeAction: {
                    coordinator.activePopup = nil
                })

        case .none:
            EmptyView()
        }
    }
    
    @ViewBuilder
    private var sheetContentView: some View {
        
        switch coordinator.activeSheet {
        case let .reportUser(reportUser, blockUser):
            container.makeReportUserSheet(onReportUser: reportUser, onBlockUser: blockUser, onCloseAction: {
                coordinator.activeSheet = nil
            })
                .background(Color.white)
                
        case .none:
            EmptyView()
        }
    }
    
    
}

#Preview {
    MainNavigationStack(container: MockMainDIContainer())
}
