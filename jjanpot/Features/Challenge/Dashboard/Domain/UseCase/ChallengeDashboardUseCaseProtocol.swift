//
//  ChallengeDashboardUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


protocol ChallengeDashboardUseCaseProtocol {
    func getChallengeDashboardData() async throws -> ChallengeDashboardEntity
    
    /// 게시글 신고
    func reportFeed(feedId: Int, reason: String) async throws
    
    /// 사용자 신고
    func reportUser(userId: Int, challengeId: Int, reason: String) async throws
    
    /// 사용자 차단
    func blockUser(userId: Int, challengeId: Int) async throws
    
    
    /// 피드 삭제하기
    func deleteFeed(feedId: Int) async throws
    
    /// 피드 좋아요
    func updateLikes(feedId: Int) async throws -> LikesEntity
}

// MARK: - ChallengeDashboardUseCase

struct ChallengeDashboardUseCase: ChallengeDashboardUseCaseProtocol {
    private let repository: ChallengeDashboardRepositoryProtocol
    init(repository: ChallengeDashboardRepositoryProtocol) {
        self.repository = repository
    }
    
    
    /// 챌린지 정보 가져오기
    func getChallengeDashboardData() async throws -> ChallengeDashboardEntity {
        guard isLoggedIn() else {
            return .none
        }
        
        // 1. 유저의 챌린지 가져오기
        let challengeEntity = try await getChallengeData()
        
        switch challengeEntity.status {
        case .none:
            return .none
            
        case let .waiting(entity):
            return .waiting(id: entity.challengeId)
            
        case let .inProgress(entity):
            // 2. 진행중일 경우, 오버뷰, 피드 가져오기
            let overview = try await getChallengeOverview(challengeId: entity.challengeId)
            let feeds = try await getFeeds(challengeId: entity.challengeId)
            return .inProgress(id: entity.challengeId, overview: overview, feeds: feeds)
        }
    }
    
    
    /// 챌린지 아이디, 상태 가져오기 from 챌린지 정보 가져오기 (홈화면용)
    private func getChallengeData() async throws -> CurrentChallengeEntity {
        return try await repository.fetchCurrentChallenge()
    }
    
    /// 진행중인 챌린지 오버뷰 가져오기
    private func getChallengeOverview(challengeId: Int) async throws -> OverviewEntity {
        try await repository.fetchChallengeOverview(challengeId: challengeId)
    }
    
    /// 진행중인 챌린지 피드 가져오기
    private func getFeeds(challengeId: Int) async throws -> [FeedEntity] {
        try await repository.fetchFeeds(challengeId: challengeId)
    }
    
    
    /// 게시글 신고
    func reportFeed(feedId: Int, reason: String) async throws {
        try await repository.reportFeed(feedId: feedId, reason: reason)
    }
    
    /// 사용자 신고
    func reportUser(userId: Int, challengeId: Int, reason: String) async throws {
        try await repository.reportUser(userId: userId, challengeId: challengeId, reason: reason)
    }
    
    /// 사용자 차단
    func blockUser(userId: Int, challengeId: Int) async throws {
        try await repository.blockUser(userId: userId, challengeId: challengeId)
    }
    
    // 피드 삭제하기
    func deleteFeed(feedId: Int) async throws {
        try await repository.deleteFeed(feedId: feedId)
    }
    
    // 피드 좋아요
    func updateLikes(feedId: Int) async throws -> LikesEntity {
        try await repository.updateLikes(feedId: feedId)
    }
    
    
    
    //MARK: private Methods..
    
    private func isLoggedIn() -> Bool {
        repository.isLoggedIn()
    }
}
