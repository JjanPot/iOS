//
//  ChallengeReportUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//


protocol ChallengeReportUseCaseProtocol {
    
}
struct ChallengeReportUseCase: ChallengeReportUseCaseProtocol {
    private let repository: ChallengeReportRepositoryProtocol
    init(repository: ChallengeReportRepositoryProtocol) {
        self.repository = repository
    }
}