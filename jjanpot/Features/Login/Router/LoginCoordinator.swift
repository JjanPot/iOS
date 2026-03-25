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
    case profileSetup
    case signUpComplete

    var id: String {
        switch self {
        case .terms:
            return "terms"
        case .profileSetup:
            return "profileSetup"
        case .signUpComplete:
            return "signUpComplete"
        }
    }

    var analyticsName: String {
        switch self {
        case .terms:
            return "login_terms_agreement"
        case .profileSetup:
            return "login_profile_setup"
        case .signUpComplete:
            return "login_signup_complete"
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

    /// 프로필 설정 화면으로 이동
    func navigateToProfileSetup() {
        path.append(LoginDestination.profileSetup)
    }

    /// 회원가입 완료 화면으로 이동
    func navigateToSignUpComplete() {
        path.append(LoginDestination.signUpComplete)
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
