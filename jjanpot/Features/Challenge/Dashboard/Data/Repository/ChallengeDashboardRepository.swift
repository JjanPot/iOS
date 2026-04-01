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

    
    func fetchChallengeOverview(challengeId: Int) async throws -> OverviewEntity {
        let result = await apiClient.fetchChallengeOverview(challengeId: challengeId)
        switch result {
        case .success(let dto):
            return OverviewEntity(from: dto)
            
        case .failure(let error):
            throw error
        }
    }
    
    
    func fetchFeed(challengeId: Int) async throws -> FeedResponseEntity {
        let result = await apiClient.fetchFeed(challengeId: challengeId)
        switch result {
        case .success(let dto):
            return FeedResponseEntity(from: dto)
            
        case .failure(let error):
            throw error
        }
    }
}
