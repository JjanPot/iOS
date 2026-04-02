//
//  LoginUseCase.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//

import Foundation

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
