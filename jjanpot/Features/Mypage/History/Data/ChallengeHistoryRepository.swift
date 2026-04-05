//
//  ChallengeHistoryRepository.swift
//  jjanpot
//
//  Created by 임주희 on 4/5/26.
//


struct ChallengeHistoryRepository: ChallengeHistoryRepositoryProtocol {
    private let apiClient: ChallengeApiClientProtocol

    init(challengeApiClient: ChallengeApiClientProtocol) {
        self.apiClient = challengeApiClient
    }
    
    func loadHistories() async throws -> [HistoryEntity] {
        let result = await apiClient.getChallengeHistory()
        switch result {
        case .success(let dtos):
            return dtos.map { HistoryEntity(from: $0) }
        case .failure(let error):
            throw error
        }
    }
}