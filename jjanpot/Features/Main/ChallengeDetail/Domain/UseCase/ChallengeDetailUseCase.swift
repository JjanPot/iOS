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
    /// 챌린지의 멤버목록 가져오기
    func getMembers(challengeId: Int) async throws -> [OverviewEntity.Member]
    
    
    /// 리뷰용 - 챌린지 즉시 시작
    func startChallenge(id challengeId: Int) async throws
    
    /// 리뷰용 - 챌린지 즉시 종료
    func finishChallenge(id challengeId: Int) async throws
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
    
    
    /// 챌린지의 멤버목록 가져오기
    func getMembers(challengeId: Int) async throws -> [OverviewEntity.Member] {
        let entity = try await repository.fetchChallengeOverview(challengeId: challengeId)
        return entity.members
    }
    
    
    func cancel(challengeId: Int) async throws {
        try await repository.cancelChallenge(challengeId: challengeId)
    }
    
    // MARK: - review ver
    
    /// 리뷰용 - 챌린지 즉시 시작
    func startChallenge(id challengeId: Int) async throws {
        try await repository.startChallenge(challengeId: challengeId)
    }
    
    /// 리뷰용 - 챌린지 즉시 종료
    func finishChallenge(id challengeId: Int) async throws {
        try await repository.finishChllaenge(challengeId: challengeId)
    }
}
