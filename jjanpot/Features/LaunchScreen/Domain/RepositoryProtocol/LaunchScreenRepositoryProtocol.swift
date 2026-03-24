//
//  LaunchScreenRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/22/26.
//


import Foundation

protocol LaunchScreenRepositoryProtocol {
    func getStoredRefreshToken() async -> String?
    func refreshToken(token: String) async throws -> RefreshTokenEntity
    func storeTokens(accessToken: String, refreshToken: String) async
    func getUserInfo() async throws -> UserEntity
    func updateUser(_ user: UserEntity) async
}
