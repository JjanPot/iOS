//
//  InviteCodePopupRepository.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


import Foundation

struct InviteCodePopupRepository: InviteCodePopupRepositoryProtocol {
    private let challengeApiClient: ChallengeApiClientProtocol
    init(challengeApiClient: ChallengeApiClientProtocol) {
        self.challengeApiClient = challengeApiClient
    }
    
//    func agreeTerms(marketingConsentAgreed: Bool ) async throws {
//        let result = await authApiClient.agreement(marketingConsentAgreed: marketingConsentAgreed)
//        switch result {
//        case .success:
//            return
//        case .failure(let error):
//            throw error
//        }
//    }
    
    func submitInviteCode(code: String) async throws {
        let result = await challengeApiClient.submitInviteCode(code: code)
        switch result {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
    
    func submitInviteCodeOnBoarding(code: String) async throws {
        let result = await challengeApiClient.submitInviteCodeInOnboarding(code: code)
        switch result {
        case .success(_):
            return
        case .failure(let error):
            throw error
        }
    }
}
