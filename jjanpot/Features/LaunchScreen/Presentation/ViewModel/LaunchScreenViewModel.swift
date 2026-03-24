//
//  LaunchScreenViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/22/26.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class LaunchScreenViewModel: ObservableObject {

    @Published var isLaunchFinished = false

    private let useCase: LaunchScreenUseCaseProtocol

    init(useCase: LaunchScreenUseCaseProtocol) {
        self.useCase = useCase
    }

    /// 앱 시작 시 인증 체크 (Task는 ViewModel이 관리)
    func checkAuth() {
        Task {
            do {
                // 갱신 후, 유저정보 가져옴 (로그인 유지) -> 메인화면으로
                try await useCase.checkAuth()
                Logger.success("토큰 갱신 및 유저 정보 갱신 성공 → 메인 화면으로")
                
            } catch {
                // 토큰갱신, 유저정보 가져오기 실패 -> 로그아웃, 로그인 화면으로
                Logger.error("토큰갱신, 유저정보 가져오기 실패")
                AuthManager.shared.logout()
            }
            Logger.debug("다음 화면으로")
            isLaunchFinished = true
            
        }
    }
}
