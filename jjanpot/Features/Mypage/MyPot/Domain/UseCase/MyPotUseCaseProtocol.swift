//
//  MyPotUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//


protocol MyPotUseCaseProtocol {
    func getMyChallengeStats() async throws -> ChallengeStatsEntity
    func getUserInfo() async throws -> UserEntity
}
struct MyPotUseCase: MyPotUseCaseProtocol {
    private let repository: MyPotRepositoryProtocol
    init(repository: MyPotRepositoryProtocol) {
        self.repository = repository
    }
    
    func getMyChallengeStats() async throws  -> ChallengeStatsEntity {
        guard isLoggedIn() else {
            return ChallengeStatsEntity(totalCount: 0,
                                        successCount: 0,
                                        failCount: 0,
                                        successRate: 0
            )
        }
        
        return try await repository.getMyChallengeStats()
    }
    
    func getUserInfo() async throws -> UserEntity {
        guard isLoggedIn() else {
            throw NetworkError.cancelled
        }
        return try await repository.getUserInfo()
    }
    
    private func isLoggedIn() -> Bool {
        repository.isLoggedIn()
    }
}


