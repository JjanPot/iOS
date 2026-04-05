//
//  LoginViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//

import Foundation
import SwiftUI
import Combine

final class LoginViewModel: ObservableObject {

    private let useCase: LoginUseCaseProtocol

    init(useCase: LoginUseCaseProtocol) {
        self.useCase = useCase
    }

    // MARK: - Output Properties

    @Published var shouldNavigateToSignup = false
    @Published var shouldNavigateToMain = false
    @Published var isLoading = false
    
    
    // MARK: - Input Methods

    func clickAppleLoginButton() {
        Logger.debug("애플 로그인 클릭")
        guard !isLoading else { return }
        Task {
            await performLogin { try await useCase.loginWithApple() }
        }
    }
    
    func clickKakaoLoginButton() {
        guard !isLoading else { return }
        Logger.debug("카카오 로그인 클릭")
        Task {
            await performLogin { try await useCase.loginWithKakao() }
        }
    }
    
    func clickGoogleLoginButton() {
        Logger.debug("구글 로그인 클릭")
        guard !isLoading else { return }
        Task {
            await performLogin { try await useCase.loginWithGoogle() }
        }
    }
    
    // MARK: - Private Methods
    
    // 로그인 공통
    @MainActor
    private func performLogin(_ loginAction: () async throws -> LoginEntity) async {
        isLoading = true
        clearData()

        do {
            let entity = try await loginAction()
            await MainActor.run {
                isLoading = false
                // 로그인 성공 처리 (토큰 + 사용자 정보 저장)
                useCase.login(entity: entity)
                
                // 신규 유저 → 회원가입 화면 (NavigationStack에 push)
                // 기존 유저 → 메인 화면 (Root 변경)
                if entity.isNewUser {
                    Logger.success("신규 유저 로그인 성공 → 회원가입 화면으로")
                    shouldNavigateToSignup = true
                } else {
                    Logger.success("기존 유저 로그인 성공 → 메인 화면으로")
                    shouldNavigateToMain = true
                }
            }

        } catch {
            // 로그인 실패
            Logger.error("로그인 실패: \(error)")
            isLoading = false
        }
    }

    private func clearData() {
        shouldNavigateToSignup = false
        shouldNavigateToMain = false
    }

}
