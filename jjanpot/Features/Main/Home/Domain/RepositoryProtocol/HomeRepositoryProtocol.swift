//
//  HomeRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import Foundation

protocol HomeRepositoryProtocol {
    
    /// 홈화면에서 챌린지 정보 가져오기
    func fetchCurrentChallenge() async throws -> CurrentChallengeEntity
    
    /// 챌린지 진행중일때, 챌린지 요약정보 가져오기
    func fetchChallengeSummary(challengeId: Int) async throws -> ChallengeSummaryEntity
}
