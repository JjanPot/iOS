//
//  ChallengeReportRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//


protocol ChallengeReportRepositoryProtocol {
    func report(challengeId: Int) async throws -> ChallengeReportEntity
    
    
    func fetchDetail(challengeId: Int) async throws -> ChallengeDetailEntity
    
    
    /// 챌린지 진행중일때, 챌린지 요약정보 가져오기
    func fetchChallengeSummary(challengeId: Int) async throws -> ChallengeSummaryEntity
}
