//
//  FeedPostUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//


import UIKit

protocol FeedPostUseCaseProtocol {
    func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity
    func postChallenge(entity: FeedPostRequestEntity, imageData: Data?) async throws
}

// MARK: - FeedPostUseCase
struct FeedPostUseCase: FeedPostUseCaseProtocol {
    private let repository: FeedPostRepositoryProtocol
    init(repository: FeedPostRepositoryProtocol) {
        self.repository = repository
    }

    func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity {
        try await repository.fetchDetail(challengeId: challengeId)
    }

    func postChallenge(entity: FeedPostRequestEntity, imageData: Data?) async throws {
        try await repository.postChallenge(entity: entity, imageData: imageData)
    }
}
