//
//  MyPotRepository.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//


import Foundation

struct MyPotRepository: MyPotRepositoryProtocol {
    private let authApiClient: AuthApiClientProtocol
    private let challengeApiClient: ChallengeApiClientProtocol

    init(authApiClient: AuthApiClientProtocol, challengeApiClient: ChallengeApiClientProtocol) {
        self.authApiClient = authApiClient
        self.challengeApiClient = challengeApiClient
    }
    
    func getMyChallengeStats() async throws -> ChallengeStatsEntity {
        let result = await challengeApiClient.getChallengeStats()
        switch result {
        case let .success(dto):
            return ChallengeStatsEntity(from: dto)
        case let .failure(error):
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
}
