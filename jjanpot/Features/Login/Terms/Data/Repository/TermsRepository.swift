//
//  TermsRepository.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


struct TermsRepository: TermsRepositoryProtocol {
    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }
    
    func agreeTerms(marketingConsentAgreed: Bool ) async throws {
        let result = await authApiClient.agreement(marketingConsentAgreed: marketingConsentAgreed)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}

