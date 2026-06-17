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
    
    func isLoggedIn () -> Bool {
        AuthManager.shared.isLoggedIn
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
    
    // 완료목록 가져오기
    func loadHistories() async throws -> [HistoryEntity] {
        let result = await apiClient.getChallengeHistory()
        switch result {
        case .success(let dtos):
            let entities = dtos.map { HistoryEntity(from: $0) }
            let sorted = entities.sorted { $0.endDate > $1.endDate }
            return sorted
            
        case .failure(let error):
            throw error
        }
    }
    
    func loadLatestCompletedChallengeId() -> Int? {
        AppConfig.shared.latestCompletedChallengeId
    }
}



