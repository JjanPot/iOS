//
//  ChallengeDetailUseCase.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//

import Foundation

protocol ChallengeDetailUseCaseProtocol {
    func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity
}

final class ChallengeDetailUseCase: ChallengeDetailUseCaseProtocol {
    
    private let repository: ChallengeDetailRepositoryProtocol

    init(repository: ChallengeDetailRepositoryProtocol) {
        self.repository = repository
    }
    
    func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity {
        try await repository.fetchDetail(challengeId: challengeId)
    }
}
