//
//  RootCoordinator.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI
import Combine

/// 앱 전체의 네비게이션 플로우를 관리하는 Coordinator
@MainActor
final class RootCoordinator: ObservableObject, RootCoordinatorProtocol {

    /// 현재 앱의 플로우 상태
    @Published var currentFlow: AppFlow = .launching

    // MARK: - Navigation Methods

    /// 로그인 화면으로 이동
    func navigateToLogin() {
        currentFlow = .login
    }

    /// 메인 화면으로 이동
    func navigateToMain() {
        currentFlow = .main
    }

    /// 스플래시 화면으로 이동 (재시작)
    func navigateToLaunching() {
        currentFlow = .launching
    }

    // MARK: - Business Logic

    /// 토큰 체크 결과에 따라 화면 분기
    /// - Parameter isValid: 토큰이 유효한지 여부
    func handleTokenCheckResult(isValid: Bool) {
        if isValid {
            navigateToMain()
        } else {
            navigateToLogin()
        }
    }
}
