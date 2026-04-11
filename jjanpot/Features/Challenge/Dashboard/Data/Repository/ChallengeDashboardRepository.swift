//
//  ChallengeDashboardRepository.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//

import Foundation

struct ChallengeDashboardRepository: ChallengeDashboardRepositoryProtocol {
    private let apiClient: ChallengeApiClientProtocol

    init(challengeApiClient: ChallengeApiClientProtocol) {
        self.apiClient = challengeApiClient
    }
    
    func isLoggedIn () -> Bool {
        AuthManager.shared.isLoggedIn
    }
    
    /// 챌린지 정보 가져오기 (홈화면용)
    func fetchCurrentChallenge() async throws -> CurrentChallengeEntity {
         let result = await apiClient.fetchChallenges()

        switch result {
        case .success(let dto):
            return try CurrentChallengeEntityMapper().map(from: dto)
            
        case .failure(let error):
            throw error
        }
    }
    
    func fetchChallengeOverview(challengeId: Int) async throws -> OverviewEntity {
        let result = await apiClient.fetchChallengeOverview(challengeId: challengeId)
        switch result {
        case .success(let dto):
            return OverviewEntity(from: dto)
            
        case .failure(let error):
            throw error
        }
    }
    
    
    func fetchFeeds(challengeId: Int) async throws -> [FeedEntity] {
        let result = await apiClient.fetchFeed(challengeId: challengeId)
        switch result {
        case .success(let dtos):
            return dtos.map{dto in FeedEntity(from: dto)}
            
        case .failure(let error):
            throw error
        }
    }
    
    // 게시글 신고
    func reportFeed(feedId: Int, reason: String) async throws {
        let result = await apiClient.reportFeed(feedId: feedId, reason: reason)
        switch result {
        case .success(let dto):
            return
            
        case .failure(let error):
            throw error
        }
    }
    
    // 사용자 신고
    func reportUser(userId: Int, challengeId: Int, reason: String) async throws {
        let result = await apiClient.reportUser(userId: userId, challengeId: challengeId, reason: reason)
        switch result {
        case .success(let dto):
            return
            
        case .failure(let error):
            throw error
        }
    }
    
    // 사용자 차단
    func blockUser(userId: Int, challengeId: Int) async throws {
        let result = await apiClient.blockUser(userId: userId, challengeId: challengeId)
        switch result {
        case .success(let dto):
            return
            
        case .failure(let error):
            throw error
        }
    }
}
