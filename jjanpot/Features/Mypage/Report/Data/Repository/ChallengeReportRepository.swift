//
//  ChallengeReportRepository.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//

import Foundation

struct ChallengeReportRepository: ChallengeReportRepositoryProtocol {
    private let apiClient: ChallengeApiClientProtocol

    init(challengeApiClient: ChallengeApiClientProtocol) {
        self.apiClient = challengeApiClient
    }
    
    /// 챌린지 결과지 가져오기
    func report(challengeId: Int) async throws -> ChallengeReportEntity {
        let result = await apiClient.getChallengeReport(challengeId: challengeId)
        switch result {
        case let .success(dto):
            return ChallengeReportEntity(from: dto)
        case let .failure(error): throw error
        }
    }
    
    /// 챌린지 상세보기 가져오기
    func fetchDetail(challengeId: Int) async throws -> ChallengeDetailEntity {
        let result = await apiClient.fetchDetail(challengeId: challengeId)

        switch result {
        case .success(let dto):
            return ChallengeDetailEntity(from: dto)
        case .failure(let error):
            throw error
        }
    }
    
    /// 챌린지 진행중일때, 챌린지 요약정보 가져오기
    func fetchChallengeSummary(challengeId: Int) async throws -> ChallengeSummaryEntity {
        let result = await apiClient.fetchChallengeSummary(challengeId: challengeId)
        switch result {
        case .success(let dto):
            return ChallengeSummaryEntityMapper().map(from: dto)
            
        case .failure(let error):
            throw error
        }
    }
}


