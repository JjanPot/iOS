//
//  MyPotUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//


protocol MyPotUseCaseProtocol {
    func getMyChallengeStats() async throws -> ChallengeStatsEntity
}
struct MyPotUseCase: MyPotUseCaseProtocol {
    private let repository: MyPotRepositoryProtocol
    init(repository: MyPotRepositoryProtocol) {
        self.repository = repository
    }
    
    
    
    func getMyChallengeStats() async throws  -> ChallengeStatsEntity{
        try await repository.getMyChallengeStats()
        
    }
}


