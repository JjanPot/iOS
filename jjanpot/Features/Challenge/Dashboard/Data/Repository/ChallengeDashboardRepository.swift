//
//  ChallengeDashboardRepository.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


struct ChallengeDashboardRepository: ChallengeDashboardRepositoryProtocol {
    private let challengeApiClient: ChallengeApiClientProtocol

    init(challengeApiClient: ChallengeApiClientProtocol) {
        self.challengeApiClient = challengeApiClient
    }

    /*
    func agreeChallengeDashboar(marketingConsentAgreed: Bool ) async throws {
        let result = await authApiClient.agreement(marketingConsentAgreed: marketingConsentAgreed)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }*/
}