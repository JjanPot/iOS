//
//  ChallengeDetailUseCase.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//

import Foundation

protocol ChallengeDetailUseCaseProtocol {
    func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity
    func cancel(challengeId: Int) async throws
}

// MARK: - ChallengeDetailUseCase

final class ChallengeDetailUseCase: ChallengeDetailUseCaseProtocol {
    
    private let repository: ChallengeDetailRepositoryProtocol

    init(repository: ChallengeDetailRepositoryProtocol) {
        self.repository = repository
    }
    
    func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity {
        try await repository.fetchDetail(challengeId: challengeId)
    }
    
    func cancel(challengeId: Int) async throws {
        try await repository.cancelChallenge(challengeId: challengeId)
    }
}
