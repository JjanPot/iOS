//
//  ChallengeDashboardRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//

import Foundation

protocol ChallengeDashboardRepositoryProtocol {
    /// 로그인 여부 확인
    func isLoggedIn () -> Bool
    
    
    /// 챌린지 정보 가져오기 (홈화면용)
    func fetchCurrentChallenge() async throws -> CurrentChallengeEntity
    
    /// 진행중 챌린지, 절약현황 가져오기
    func fetchChallengeOverview(challengeId: Int) async throws -> OverviewEntity
    
    /// 챌린지 피드 가져오기
    func fetchFeeds(challengeId: Int) async throws -> [FeedEntity]
    
    /// 게시글 신고
    func reportFeed(feedId: Int, reason: String) async throws
    
    /// 사용자 신고
    func reportUser(userId: Int, challengeId: Int, reason: String) async throws
    
    /// 사용자 차단
    func blockUser(userId: Int, challengeId: Int) async throws
}
