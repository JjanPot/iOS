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
            Logger.success("토큰 갱신 성공")
            return RefreshTokenEntity(
                userId: dto.userId,
                accessToken: dto.accessToken,
                refreshToken: dto.refreshToken
            )
        case .failure(let error):
            throw error
        }
    }
    
    // 유저 정보 가져오기
    func getUserInfo() async throws -> UserEntity {
        let result = await authApiClient.getProfile()
        switch result {
        case let .success(dto):
            return UserEntity(from: dto)
            
        case let .failure(error):
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
    

    // 유저 정보 업데이트
    func updateUser(_ user: UserEntity) async {
        AuthManager.shared.updateUser(user)
    }
}
