//
//  TermsRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


protocol TermsRepositoryProtocol {
    func agreeTerms(marketingConsentAgreed: Bool ) async throws
}
