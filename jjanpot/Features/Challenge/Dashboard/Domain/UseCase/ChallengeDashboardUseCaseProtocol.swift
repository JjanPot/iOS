//
//  ChallengeDashboardUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


protocol ChallengeDashboardUseCaseProtocol {
    func fetchChallengeOverview(challengeId: Int) async throws -> OverviewEntity
    func fetchFeed(challengeId: Int) async throws -> FeedResponseEntity
}
struct ChallengeDashboardUseCase: ChallengeDashboardUseCaseProtocol {
    private let repository: ChallengeDashboardRepositoryProtocol
    init(repository: ChallengeDashboardRepositoryProtocol) {
        self.repository = repository
    }
    
    func fetchChallengeOverview(challengeId: Int) async throws -> OverviewEntity {
        try await repository.fetchChallengeOverview(challengeId: challengeId)
    }
    func fetchFeed(challengeId: Int) async throws -> FeedResponseEntity {
        try await repository.fetchFeed(challengeId: challengeId)
    }
    
}

