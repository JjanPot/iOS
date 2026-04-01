//
//  ChallengeDashboardRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


protocol ChallengeDashboardRepositoryProtocol {
    func fetchChallengeOverview(challengeId: Int) async throws -> OverviewEntity
    func fetchFeed(challengeId: Int) async throws -> FeedResponseEntity
}
