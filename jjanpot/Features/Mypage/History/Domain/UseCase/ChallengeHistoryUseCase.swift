//
//  ChallengeHistoryUseCase.swift
//  jjanpot
//
//  Created by 임주희 on 4/5/26.
//


struct ChallengeHistoryUseCase: ChallengeHistoryUseCaseProtocol {
    private let repository: ChallengeHistoryRepositoryProtocol
    init(repository: ChallengeHistoryRepositoryProtocol) {
        self.repository = repository
    }
    
    func loadHistories() async throws -> [HistoryEntity] {
        try await repository.loadHistories()
    }
}