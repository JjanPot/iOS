//
//  AuthManager.swift
//  jjanpot
//
//  Created by 임주희 on 3/18/26.
//


import Foundation
import Combine

/// 로그인 상태와 사용자 정보를 관리
final class AuthManager: ObservableObject {

    static let shared = AuthManager()

    // MARK: - Storage (Keychain)

    @Keychain(key: "accessToken") private var accessToken: String?
    @Keychain(key: "refreshToken") private var refreshToken: String?
    
    // MARK: - Storage (UserDefault)

    @UserDefault(key: "fcmToken", defaultValue: nil)
    private var fcmToken: String?
    
    // MARK: - Published Properties

    /// 현재 로그인 여부 (토큰 유무로 판단)
    @Published private(set) var isLoggedIn: Bool = false

    /// 현재 사용자 정보 (메모리에만 유지, 스플래시에서 API로 받아옴)
    @Published private(set) var currentUser: UserEntity?

    // MARK: - Init

    private init() {
        // 앱 시작 시 저장된 로그인 상태 복원
        loadLoginState()
    }

    // MARK: - Public Methods

    /// 로그인 성공 시 호출 (토큰만 Keychain에 저장, 유저 정보는 메모리에만)
    func login(_ entity: LoginEntity) {
        // 1. 토큰 저장 (Keychain)
        self.accessToken = entity.accessToken
        self.refreshToken = entity.refreshToken

        // 2. 상태 업데이트 (메모리에만)
        currentUser = entity.user
        isLoggedIn = true

        Logger.success("로그인 성공: \(entity.user.nickname) (userId: \(entity.user.userId))")

    }
    
    
    /// 토큰갱신
    func refreshToken(accessToken: String, refreshToken: String){
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }

    /// 로그아웃
    func logout() {
        // 1. 토큰 삭제 (Keychain)
        accessToken = nil
        refreshToken = nil

        // 2. 상태 업데이트 (메모리)
        currentUser = nil
        isLoggedIn = false

        Logger.success("로그아웃 완료")
    }

    /// Access Token 가져오기 (API 호출 시 사용)
    func getAccessToken() -> String? {
        return accessToken
    }

    /// Refresh Token 가져오기
    func getRefreshToken() -> String? {
        return refreshToken
    }
    
    func getFcmToken() -> String? {
        return fcmToken
    }

    /// 닉네임 업데이트
    func updateNickname(_ nickname: String) {
        guard let user = currentUser else { return }
        let updatedUser = UserEntity(
            userId: user.userId,
            nickname: nickname
        )
        updateUser(updatedUser)
    }

    /// 사용자 정보 업데이트 (메모리에만)
    func updateUser(_ user: UserEntity) {
        currentUser = user
        Logger.success("사용자 정보 업데이트: \(user.nickname)")
    }
    
    func updateFcm(token: String?){
        fcmToken = token
        Logger.success("fcm token 업데이트 \(token ?? "-missing token-")")
    }

    // MARK: - Private Methods

    /// 앱 시작 시 저장된 로그인 상태 복원 (토큰만 확인)
    private func loadLoginState() {
        // 토큰 유무로 로그인 상태 판단
        isLoggedIn = accessToken != nil && refreshToken != nil

        if isLoggedIn {
            Logger.info("저장된 토큰 발견 → 스플래시에서 유저 정보 로드 예정")
        } else {
            Logger.info("저장된 토큰 없음 → 로그인 필요")
        }
    }
}
