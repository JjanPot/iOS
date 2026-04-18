//
//  FeedEditRepository.swift
//  jjanpot
//
//  Created by 임주희 on 4/18/26.
//

import Foundation

struct FeedEditRepository: FeedEditRepositoryProtocol {
    private let apiClient: ChallengeApiClientProtocol

    init(challengeApiClient: ChallengeApiClientProtocol) {
        self.apiClient = challengeApiClient
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
    
    func updateFeed(feedId: Int, entity: FeedPostRequestEntity, imageData: Data?) async throws {
        let dto = FeedPostRequestDto(from: entity)
        let result = await apiClient.updateFeed(feedId: feedId, dto: dto, imageData: imageData)
        
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}
