//
//  FeedEditUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/18/26.
//

import Foundation

protocol FeedEditUseCaseProtocol {
    func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity
    func updateFeed(feedId: Int, entity: ChallengePostRequestEntity, imageData: Data?) async throws
}
struct FeedEditUseCase: FeedEditUseCaseProtocol {
    private let repository: FeedEditRepositoryProtocol
    init(repository: FeedEditRepositoryProtocol) {
        self.repository = repository
    }
    
    
    func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity {
        try await repository.fetchDetail(challengeId: challengeId)
    }
    
    func updateFeed(feedId: Int, entity: ChallengePostRequestEntity, imageData: Data?) async throws {
        try await repository.updateFeed(feedId: feedId, entity: entity, imageData: imageData)
    }
}

