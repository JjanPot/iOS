//
//  HomeRepository.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import Foundation

struct HomeRepository: HomeRepositoryProtocol {
    
    private let apiClient: ChallengeApiClientProtocol
    
    init(apiClient: ChallengeApiClientProtocol) {
        self.apiClient = apiClient
    }
    
    /// 홈화면에서 챌린지 정보 가져오기
    func fetchCurrentChallenge() async throws -> CurrentChallengeEntity {
         let result = await apiClient.fetchChallenges()

        switch result {
        case .success(let dto):
            return try CurrentChallengeEntityMapper().map(from: dto)
            
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

struct ChallengeSummaryEntity {
    let team: Team
    let personal: Personal
    

    struct Team {
        
        let avgCertificationCount: Double
        // 참여율
        let participationRate: Int
        // 연속활동
        let consecutiveDays: Int
    }
    
    struct Personal {
        // 인증횟수
        let certificationCount: Int
        // 참여율
        let participationRate: Int
        // 연속활동
        let consecutiveDays: Int
    }
}

struct ChallengeSummaryEntityMapper {
    func map(from dto: ChallengeSummaryDto) -> ChallengeSummaryEntity {
        ChallengeSummaryEntity(
            team: ChallengeSummaryEntity.Team(
                avgCertificationCount: dto.team.avgCertificationCount,
                participationRate: dto.team.participationRate,
                consecutiveDays: dto.team.consecutiveDays
            ),
            personal: ChallengeSummaryEntity.Personal(
                certificationCount: dto.personal.certificationCount,
                participationRate: dto.personal.participationRate,
                consecutiveDays: dto.personal.consecutiveDays
            )
        )
    }
}
