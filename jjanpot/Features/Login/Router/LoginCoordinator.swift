//
//  LoginCoordinator.swift
//  jjanpot
//
//  Created by 임주희 on 3/24/26.
//

import SwiftUI
import Combine

enum LoginDestination: Route {
    case terms
    case inviteCode

    var id: String {
        switch self {
        case .terms:
            return "terms"
        case .inviteCode:
            return "inviteCode"
        }
    }

    var analyticsName: String {
        switch self {
        case .terms:
            return "login_terms_agreement"
        case .inviteCode:
            return "login_invite_code_input"
        }
    }

    var hidesTabBar: Bool {
        // 로그인 플로우는 탭바가 없으므로 기본값(false) 사용
        return false
    }
}

@MainActor
final class LoginCoordinator: ObservableObject {
    private let loginDIContainer: LoginDIContainerProtocol

    @Published var path = NavigationPath()

    init(loginDIContainer: LoginDIContainerProtocol) {
        self.loginDIContainer = loginDIContainer
    }

    // MARK: - Navigation Methods

    /// 약관 동의 화면으로 이동
    func navigateToTerms() {
        path.append(LoginDestination.terms)
    }

    /// 초대 코드 입력 화면으로 이동
    func navigateToInviteCode() {
        path.append(LoginDestination.inviteCode)
    }

    /// 특정 화면으로 이동
    func push(_ destination: LoginDestination) {
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

    // MARK: - View Factory Methods

    func makeWebView(url: String, onDismiss: @escaping () -> Void) -> AnyView {
        loginDIContainer.makeWebView(url: url, onDismiss: onDismiss)
    }
}
