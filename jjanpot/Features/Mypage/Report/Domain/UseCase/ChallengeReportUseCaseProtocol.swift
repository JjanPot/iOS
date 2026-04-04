//
//  ChallengeReportUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//


protocol ChallengeReportUseCaseProtocol {
    func report(challengeId: Int) async throws -> ChallengeReportEntity
    func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity
    func fetchChallengeSummary(challengeId: Int) async throws -> ChallengeSummaryEntity
}

struct ChallengeReportUseCase: ChallengeReportUseCaseProtocol {
    private let repository: ChallengeReportRepositoryProtocol
    init(repository: ChallengeReportRepositoryProtocol) {
        self.repository = repository
    }
    
    func report(challengeId: Int) async throws -> ChallengeReportEntity {
        try await repository.report(challengeId: challengeId)
    }
    
    func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity {
        try await repository.fetchDetail(challengeId: challengeId)
    }
    
    
    func fetchChallengeSummary(challengeId: Int) async throws -> ChallengeSummaryEntity {
        try await repository.fetchChallengeSummary(challengeId: challengeId)
    }
}
