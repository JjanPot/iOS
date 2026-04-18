//
//  ChallengeDetailRepository.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//

import Foundation


final class ChallengeDetailRepository: ChallengeDetailRepositoryProtocol {
    private let apiClient: ChallengeApiClientProtocol

    init(apiClient: ChallengeApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    func fetchDetail(challengeId: Int) async throws -> ChallengeDetailEntity {
        let result = await apiClient.fetchDetail(challengeId: challengeId)

        switch result {
        case .success(let dto):
            return ChallengeDetailEntity(from: dto)
        case .failure(let error):
            throw error
        }
    }
    
    func cancelChallenge(challengeId: Int) async throws {
        let result = await apiClient.deleteChallenge(challengeId: challengeId)
        
        switch result {
        case .success:
            break
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
}


