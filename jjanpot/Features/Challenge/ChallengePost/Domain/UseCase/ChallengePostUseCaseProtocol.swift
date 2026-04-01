//
//  ChallengePostUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//


protocol ChallengePostUseCaseProtocol {
    
}
struct ChallengePostUseCase: ChallengePostUseCaseProtocol {
    private let repository: ChallengePostRepositoryProtocol
    init(repository: ChallengePostRepositoryProtocol) {
        self.repository = repository
    }
}
