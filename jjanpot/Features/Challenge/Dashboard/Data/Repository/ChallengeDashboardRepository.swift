//
//  ChallengeDashboardRepository.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//

import Foundation


struct ChallengeDashboardRepository: ChallengeDashboardRepositoryProtocol {
    private let apiClient: ChallengeApiClientProtocol

    init(challengeApiClient: ChallengeApiClientProtocol) {
        self.apiClient = challengeApiClient
    }

    
    /// 챌린지 정보 가져오기 (홈화면용)
    func fetchCurrentChallenge() async throws -> CurrentChallengeEntity {
         let result = await apiClient.fetchChallenges()

        switch result {
        case .success(let dto):
            return try CurrentChallengeEntityMapper().map(from: dto)
            
        case .failure(let error):
            throw error
        }
    }
    
    func fetchChallengeOverview(challengeId: Int) async throws -> OverviewEntity {
        let result = await apiClient.fetchChallengeOverview(challengeId: challengeId)
        switch result {
        case .success(let dto):
            return OverviewEntity(from: dto)
            
        case .failure(let error):
            throw error
        }
    }
    
    
    func fetchFeeds(challengeId: Int) async throws -> [FeedEntity] {
        let result = await apiClient.fetchFeed(challengeId: challengeId)
        switch result {
        case .success(let dtos):
            return dtos.map{dto in FeedEntity(from: dto)}
            
        case .failure(let error):
            throw error
        }
    }
}
