//
//  ChallengeDetailRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


protocol ChallengeDetailRepositoryProtocol {
    func fetchDetail(challengeId: Int) async throws -> ChallengeDetailEntity
    func cancelChallenge(challengeId: Int) async throws
    
    func fetchChallengeOverview(challengeId: Int) async throws -> OverviewEntity
}
