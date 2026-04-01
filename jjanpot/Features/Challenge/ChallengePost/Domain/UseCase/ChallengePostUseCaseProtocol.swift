//
//  ChallengePostUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//


import UIKit

protocol ChallengePostUseCaseProtocol {
    func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity
    func postChallenge(entity: ChallengePostRequestEntity, image: UIImage?) async throws
}

struct ChallengePostUseCase: ChallengePostUseCaseProtocol {
    private let repository: ChallengePostRepositoryProtocol
    init(repository: ChallengePostRepositoryProtocol) {
        self.repository = repository
    }

    func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity {
        try await repository.fetchDetail(challengeId: challengeId)
    }

    func postChallenge(entity: ChallengePostRequestEntity, image: UIImage?) async throws {
        try await repository.postChallenge(entity: entity, image: image)
    }
}
