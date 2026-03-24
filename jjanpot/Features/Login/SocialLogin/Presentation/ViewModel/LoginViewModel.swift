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
    
    /// 로그인 성공여부
    @Published var isLoggedIn = false
    
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
                isLoggedIn = true
                // 로그인 성공 처리 (토큰 + 사용자 정보 저장)
                useCase.login(entity: entity)
            }
            
        } catch {
            // 로그인 실패
            Logger.error("로그인 실패: \(error)")
            isLoggedIn = false
            isLoading = false
        }
    }
    
    private func clearData(){
        isLoggedIn = false
    }

}
