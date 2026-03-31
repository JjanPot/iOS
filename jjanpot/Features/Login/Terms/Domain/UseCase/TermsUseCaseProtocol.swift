//
//  TermsUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


protocol TermsUseCaseProtocol {
    func agreeTerms(marketingConsentAgreed: Bool ) async throws
}
struct TermsUseCase: TermsUseCaseProtocol {
    private let repository: TermsRepositoryProtocol
    init(repository: TermsRepositoryProtocol) {
        self.repository = repository
    }
    
    func agreeTerms(marketingConsentAgreed: Bool ) async throws {
        try await repository.agreeTerms(marketingConsentAgreed: marketingConsentAgreed)
    }
}
