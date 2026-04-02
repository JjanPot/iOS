//
//  ChallengeDashboardRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//

import Foundation

protocol ChallengeDashboardRepositoryProtocol {
    /// 챌린지 정보 가져오기 (홈화면용)
    func fetchCurrentChallenge() async throws -> CurrentChallengeEntity
    
    /// 진행중 챌린지, 절약현황 가져오기
    func fetchChallengeOverview(challengeId: Int) async throws -> OverviewEntity
    
    /// 챌린지 피드 가져오기
    func fetchFeeds(challengeId: Int) async throws -> [FeedEntity]
}
