//
//  RootCoordinatorProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/14/26.
//

import Foundation

/// 앱 전체의 플로우 상태
enum AppFlow {
    /// 스플래시 화면 (토큰 체크)
    case launching
    /// 로그인 플로우
    case login
    /// 메인 플로우 (인증된 사용자)
    case main
}

/// 앱 전체의 네비게이션 플로우를 관리하는 Protocol
protocol RootCoordinatorProtocol: AnyObject {
    var currentFlow: AppFlow { get }

    func navigateToLogin()
    func navigateToMain()
    func navigateToLaunching()
    func handleTokenCheckResult(isValid: Bool)
}
