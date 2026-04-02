//
//  LoginNavigationStack.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

/// 로그인 플로우의 독립적인 NavigationStack
/// App 레벨에서 분기되어 로그인 관련 화면들을 관리합니다.
struct LoginNavigationStack: View {
    @StateObject private var coordinator: LoginCoordinator

    private let loginDIContainer: LoginDIContainerProtocol
    let onLoginSuccess: () -> Void

    init(onLoginSuccess: @escaping () -> Void) {
        self.onLoginSuccess = onLoginSuccess
        let diContainer = AppDIContainer.shared.loginDIContainer
        self.loginDIContainer = diContainer
        _coordinator = StateObject(wrappedValue: diContainer.makeLoginCoordinator())
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            // 로그인 화면
            loginDIContainer.makeLoginView(
                coordinator: coordinator,
                onNavigateToMain: onLoginSuccess
            )
            .navigationDestination(for: LoginDestination.self) { destination in
                switch destination {
                case .terms:
                    loginDIContainer.makeTermsView(coordinator: coordinator)
                case .profileSetup:
                    loginDIContainer.makeProfileSetupView(coordinator: coordinator)
                case .signUpComplete:
                    loginDIContainer.makeSignUpCompleteView(onNavigateToMain: onLoginSuccess)
                case .inviteCode:
                    loginDIContainer.makeInviteCodeView(hasSkip: true)
                }
            }
        }
    }
}

#Preview {
    LoginNavigationStack {
        print("Login success")
    }
}

