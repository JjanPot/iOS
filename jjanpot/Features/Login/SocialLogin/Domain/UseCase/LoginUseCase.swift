//
//  LoginUseCase.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//

@preconcurrency import Foundation
@preconcurrency import FirebaseMessaging

// MARK: LoginUseCase
final class LoginUseCase: LoginUseCaseProtocol {
    private let repository: LoginRepositoryProtocol
    private var appleLogin: SocialLoginProtocol
    private var kakaoLogin: SocialLoginProtocol
    private var googleLogin: SocialLoginProtocol

    init(repository: LoginRepositoryProtocol) {
        self.repository = repository
        self.appleLogin = AppleLogin()
        self.kakaoLogin = KakaoLogin()
        self.googleLogin = GoogleLogin()
    }

    func loginWithApple() async throws -> LoginEntity {
        Logger.debug("애플 로그인")
        return try await performSocialLogin(type: .apple, socialLogin: appleLogin)
    }

    func loginWithKakao() async throws -> LoginEntity {
        Logger.debug("카카오 로그인")
        return try await performSocialLogin(type: .kakao, socialLogin: kakaoLogin)
    }

    func loginWithGoogle() async throws -> LoginEntity {
        return try await performSocialLogin(type: .google, socialLogin: googleLogin)
    }
    
    // 로그인 성공 처리 (토큰 + 사용자 정보 저장)
    func login(entity: LoginEntity){
        Logger.success("로그인 성공 \(entity)")
        AuthManager.shared.login(entity)
    }
    
    private func fetchFCMToken() async throws -> String? {
        try await Messaging.messaging().token()
    }

    /// FCM 토큰 획득 (우선순위: AuthManager → Firebase API → Notification)
    /// - Returns: FCM 토큰 또는 nil
    func getFCMToken() async -> String? {
        
        // 1. AuthManager에서 이미 저장된 토큰 확인
        if let token = AuthManager.shared.getFcmToken() {
            Logger.success("✅ AuthManager에서 FCM 토큰 획득: \(token)")
            return token
        }

        // 2. Firebase Messaging API에서 가져오기
        if let token = try? await fetchFCMToken() {
            Logger.success("✅ Firebase API에서 FCM 토큰 획득: \(token)")
            return token
        }
        
        // 3. notification 기다리기
        Logger.info("🕐 FCM 토큰 대기 중...")
        if let token = await waitForFCMToken(timeout: 3.0) {
            Logger.success("✅ Notification에서 FCM 토큰 획득: \(token)")
            return token
        }

        Logger.error("❌ FCM 토큰 획득 실패")
        return nil
    }

    /// FCM 토큰을 기다렸다가 받으면 반환 (타임아웃 시 nil)
    /// - Parameter timeout: 대기 시간 (초)
    /// - Returns: FCM 토큰 또는 nil
    func waitForFCMToken(timeout: TimeInterval) async -> String? {
        Logger.debug("🕐 FCM 토큰 수신 대기 중...")

        return await withCheckedContinuation { continuation in
            var observer: NSObjectProtocol?

            // FCM 토큰 notification 구독
            observer = NotificationCenter.default.addObserver(
                forName: Notification.Name("FCMToken"),
                object: nil,
                queue: .main
            ) { [observer] notification in
                if let token = notification.userInfo?["token"] as? String, !token.isEmpty {
                    Logger.success("✅ FCM 토큰 수신 완료: \(token)")
                    if let obs = observer {
                        NotificationCenter.default.removeObserver(obs)
                    }
                    continuation.resume(returning: token)
                }
            }

            // 타임아웃: 지정된 시간 동안 못받으면 nil 반환
            DispatchQueue.main.asyncAfter(deadline: .now() + timeout) { [observer] in
                Logger.error("⏱️  FCM 토큰 수신 타임아웃 (\(timeout)초)")
                if let obs = observer {
                    NotificationCenter.default.removeObserver(obs)
                }
                continuation.resume(returning: nil)
            }
        }
    }

    // MARK: - Private Methods

    private func performSocialLogin(type: LoginType, socialLogin: SocialLoginProtocol) async throws -> LoginEntity {
        // SocialLogin의 Delegate 콜백을 async로 변환
        let token = try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<String, Error>) in
            var tempSocialLogin = socialLogin
            tempSocialLogin.delegate = SocialLoginDelegateWrapper(continuation: continuation)
            tempSocialLogin.login()
        }
        
        let fcmToken = await repository.getFcmToken()
        let uuid = repository.getUUID()

        // 서버 로그인 처리
        let result = await performLogin(type: type, accessToken: token, deviceUuid: uuid, fcmToken: fcmToken)

        switch result {
        case .success(let entity):
            return entity

        case .failure(let error):
            throw error
        }
    }
    
    private func performLogin(type: LoginType, accessToken: String, deviceUuid: String, fcmToken: String?) async -> Result<LoginEntity, NetworkError> {
        switch type {
        case .apple:
            return await repository.appleLogin(accessToken: accessToken, deviceUuid: deviceUuid, fcmToken: fcmToken)
        case .kakao:
            return await repository.kakaoLogin(accessToken: accessToken, deviceUuid: deviceUuid, fcmToken: fcmToken)
        case .google:
            return await repository.googleLogin(accessToken: accessToken, deviceUuid: deviceUuid, fcmToken: fcmToken)
        }
    }
}

// MARK: - SocialLoginDelegateWrapper

private class SocialLoginDelegateWrapper: SocialLoginDelegate {
    private let continuation: CheckedContinuation<String, Error>
    private var hasResumed = false

    init(continuation: CheckedContinuation<String, Error>) {
        self.continuation = continuation
    }

    func didLogin(type: LoginType, didReceiveToken token: String?, error: Error?) {
        guard !hasResumed else { return }
        hasResumed = true
        Logger.info("didLogin \(type), \(token)")

        if let error = error {
            continuation.resume(throwing: error)
        } else if let token = token {
            continuation.resume(returning: token)
        } else {
            continuation.resume(throwing: NSError(domain: "LoginError", code: -1, userInfo: [NSLocalizedDescriptionKey: "로그인 실패"]))
        }
    }
}
