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

    @Published var shouldNavigateToTerms = false // 약관 동의 화면으로
    @Published var shouldNavigateToSignup = false //프로필 생성 화면으로
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
    
    // 알림 권한 요청
    func requestAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            // 1. 아직 결정되지 않았을 때만 팝업 요청
            if settings.authorizationStatus == .notDetermined {
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    if granted {
                        // 권한을 얻은 즉시 APNs에 등록 시도
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            }
            // 2. 이미 허용된 상태라면? 혹시 모르니 APNs 등록 한 번 더 시도 (안전함)
            else if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    
    // MARK: - Private Methods
    
    // 로그인 공통
    @MainActor
    private func performLogin(_ loginAction: () async throws -> LoginEntity) async {
        isLoading = true
        clearData()

        do {
            // 로딩 중에 FCM 토큰 획득 (AuthManager → Firebase API → Notification 순서)
            if let token = await useCase.getFCMToken() {
                Logger.success("✅ FCM 토큰 획득: \(token)")
            } else {
                Logger.error("⏱️ FCM 토큰 못받음 (계속 진행)")
            }

            let entity = try await loginAction()
            await MainActor.run {
                isLoading = false
               
                // 로그인 성공, 상태에 따라 화면 분기
                // 신규 유저 → 회원가입 화면 (NavigationStack에 push)
                // 기존 유저 → 메인 화면 (Root 변경)
                switch entity.nextOnboardingStep {
                case .agreement:
                    Logger.success("신규 유저 로그인 성공 → 약관동의 화면으로")
                    // 토큰 임시저장
                    useCase.tempLogin(entity: entity)
                    shouldNavigateToTerms = true
                    
                case .profile:
                    Logger.success("신규 유저 로그인 성공 → 회원가입(프로필) 화면으로")
                    // 토큰 임시저장
                    useCase.tempLogin(entity: entity)
                    shouldNavigateToSignup = true
                    
                case .completed:
                    Logger.success("기존 유저 로그인 성공 → 메인 화면으로")
                    
                    // 로그인 성공 처리 (토큰 + 사용자 정보 저장)
                    useCase.login(entity: entity)
            
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
