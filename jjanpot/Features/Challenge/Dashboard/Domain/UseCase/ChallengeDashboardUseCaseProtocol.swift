//
//  ChallengeDashboardUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


protocol ChallengeDashboardUseCaseProtocol {
    
}
struct ChallengeDashboardUseCase: ChallengeDashboardUseCaseProtocol {
    private let repository: ChallengeDashboardRepositoryProtocol
    init(repository: ChallengeDashboardRepositoryProtocol) {
        self.repository = repository
    }
}

