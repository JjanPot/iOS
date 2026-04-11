//
//  HomeUseCase.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import Foundation

final class HomeUseCase: HomeUseCaseProtocol {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func fetchChallengeData() async throws -> HomeEntity {
        guard isLoggedIn() else {
            return HomeEntity(challenge: .init(status: .none), summary: nil)
        }
        
        let challengeEntity = try await repository.fetchCurrentChallenge()

        // 진행중 상태면, summary정보 가져오기
        let summaryEntity: ChallengeSummaryEntity?
        if case let .inProgress(entity) = challengeEntity.status {
            summaryEntity = try await fetchChallengeSummary(challengeId: entity.challengeId)
        } else {
            summaryEntity = nil
        }

        return HomeEntity(
            challenge: challengeEntity,
            summary: summaryEntity
        )
    }

    private func fetchChallengeSummary(challengeId: Int) async throws -> ChallengeSummaryEntity {
        try await repository.fetchChallengeSummary(challengeId: challengeId)
    }
    
    
    func loadHistories() async throws -> [HistoryEntity] {
        guard isLoggedIn() else {
            return []
        }
        return try await repository.loadHistories()
    }
    
    func loadLatestCompletedChallengeId() -> Int? {
        repository.loadLatestCompletedChallengeId()
    }
    
    private func isLoggedIn() -> Bool {
        repository.isLoggedIn()
    }
}
