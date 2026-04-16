//
//  LoginUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation

protocol LoginUseCaseProtocol {
    func loginWithApple() async throws -> LoginEntity
    func loginWithKakao() async throws -> LoginEntity
    func loginWithGoogle() async throws -> LoginEntity

    /// 로그인 성공 처리 (토큰 + 사용자 정보 저장)
    func login(entity: LoginEntity)

    /// FCM 토큰 획득 (AuthManager → Firebase API → Notification 순서로 시도)
    func getFCMToken() async -> String?

    /// FCM 토큰을 기다렸다가 받으면 반환 (타임아웃 시 nil)
    func waitForFCMToken(timeout: TimeInterval) async -> String?
}
