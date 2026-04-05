//
//  MainCoordinator.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI
import Combine

enum MainDestination: Route {
    case createChallenge
    case challengeDetail(id: Int)
    case challengePost(id: Int)
    // MyPage destinations
    case settings
    case alarmSettings
    case challengeReport(id: Int)
    case challengeHistory

    var id: String {
        switch self {
        case .createChallenge:
            return "createChallenge"
        case .challengeDetail:
            return "challengeDetail"
        case .challengePost:
            return "challengePost"
        case .settings:
            return "settings"
        case .alarmSettings:
            return "alarmSettings"
        case .challengeReport:
            return "challengeReport"
        case .challengeHistory:
            return "challengeHistory"
        }
    }

    var analyticsName: String {
        switch self {
        case .createChallenge:
            return "main_create_challenge"
        case .challengeDetail:
            return "challenge_detail"
        case .challengePost:
            return "challengePost"
        case .settings:
            return "settings"
        case .alarmSettings:
            return "alarm_settings"
        case .challengeReport:
            return "challenge_report"
        case .challengeHistory:
            return "challengeHistory"
        }
    }

    var hidesTabBar: Bool {
        switch self {
        case .createChallenge:
            return true
        case .challengeDetail, .challengePost, .settings, .alarmSettings, .challengeReport,
                .challengeHistory:
            return true
        }
    }
}
enum MainPopupDestination {
    case inviteCode_Input
    case inviteCode_Copy(inviteCode: String)
    case reportPopup(challengeId: Int)
}

@MainActor
final class MainCoordinator: ObservableObject {
    private let container: MainDIContainerProtocol
    @Published var path = NavigationPath()
    @Published var activePopup: MainPopupDestination?

    init(container: MainDIContainerProtocol) {
        self.container = container
    }

    // MARK: - Navigation Methods


    /// 특정 화면으로 이동
    func push(_ destination: MainDestination) {
        path.append(destination)
    }

    /// 이전 화면으로 돌아가기
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    /// 특정 개수만큼 뒤로 가기
    func pop(count: Int) {
        guard path.count >= count else { return }
        path.removeLast(count)
    }

    /// 네비게이션 스택 초기화 (루트로 이동)
    func popToRoot() {
        path = NavigationPath()
    }
}
