//
//  LaunchScreenViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/22/26.
//

import Foundation
import SwiftUI
import Combine

/// 스플래시 화면의 토큰 체크 로직만 담당
/// 결과는 AppCoordinator에게 전달하여 화면 분기는 App 레벨에서 처리
@MainActor
final class LaunchScreenViewModel: ObservableObject {

    private let useCase: LaunchScreenUseCaseProtocol
    private weak var appCoordinator: AppCoordinator?

    init(useCase: LaunchScreenUseCaseProtocol, appCoordinator: AppCoordinator? = nil) {
        self.useCase = useCase
        self.appCoordinator = appCoordinator
    }

    /// 앱 시작 시 인증 체크 (순수하게 토큰 체크만 담당)
    func checkAuth() {
        Task {
            do {
                // 갱신 후, 유저정보 가져옴 (로그인 유지)
                try await useCase.checkAuth()
                Logger.success("토큰 갱신 및 유저 정보 갱신 성공 → 메인 화면으로")

                // 결과를 AppCoordinator에게 전달
                appCoordinator?.handleTokenCheckResult(isValid: true)

            } catch {
                // 토큰갱신, 유저정보 가져오기 실패 -> 로그아웃
                Logger.error("토큰갱신, 유저정보 가져오기 실패 → 로그인 화면으로")
                AuthManager.shared.logout()

                // 결과를 AppCoordinator에게 전달
                appCoordinator?.handleTokenCheckResult(isValid: false)
            }
        }
    }
}
