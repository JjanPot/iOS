//
//  LaunchScreenRepository.swift
//  jjanpot
//
//  Created by 임주희 on 3/22/26.
//


import Foundation

struct LaunchScreenRepository: LaunchScreenRepositoryProtocol {

    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }

    func getStoredRefreshToken() async -> String? {
        return AuthManager.shared.getRefreshToken()
    }

    // 토큰 갱신
    func refreshToken(token: String) async throws -> RefreshTokenEntity {
        let result = await authApiClient.refreshToken(refreshToken: token)

        switch result {
        case .success(let dto):
            return RefreshTokenEntity(
                userId: dto.userId,
                accessToken: dto.accessToken,
                refreshToken: dto.refreshToken
            )
        case .failure(let error):
            throw error
        }
    }

    // 토큰 저장
    func storeTokens(accessToken: String, refreshToken: String) async {
        AuthManager.shared.refreshToken(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
    
    
    // 유저 정보 가져오기
    func getUserInfo() async throws -> UserEntity {
        // TODO: User API Client 구현 필요
        // 현재는 임시로 AuthManager의 currentUser를 반환
        guard let user = AuthManager.shared.currentUser else {
            throw NetworkError.unauthorized
        }
        return user
    }

    // 유저 정보 업데이트
    func updateUser(_ user: UserEntity) async {
        AuthManager.shared.updateUser(user)
    }
}
