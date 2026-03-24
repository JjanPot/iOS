//
//  LaunchScreenUseCase.swift
//  jjanpot
//
//  Created by 임주희 on 3/22/26.
//

import Foundation

protocol LaunchScreenUseCaseProtocol {
    func checkAuth() async throws
}

class LaunchScreenUseCase: LaunchScreenUseCaseProtocol {
    private let repository: LaunchScreenRepositoryProtocol

    init(repository: LaunchScreenRepositoryProtocol) {
        self.repository = repository
    }
    
    
    func checkAuth() async throws {
        // 1. 저장된 Refresh Token 확인
        guard let refreshToken = await repository.getStoredRefreshToken() else {
            throw NetworkError.unauthorized
        }

        // 2. 토큰 갱신 요청
        let tokenEntity = try await repository.refreshToken(token: refreshToken)

        // 3. 새 토큰 저장
        await repository.storeTokens(
            accessToken: tokenEntity.accessToken,
            refreshToken: tokenEntity.refreshToken
        )

        // 4. 유저 정보 조회 및 저장
        let user = try await repository.getUserInfo()
        await repository.updateUser(user)
    }
}
