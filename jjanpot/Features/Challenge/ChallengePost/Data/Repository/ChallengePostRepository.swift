//
//  ChallengePostRepository.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import Foundation

struct ChallengePostRepository: ChallengePostRepositoryProtocol {
    private let challengeApiClient: ChallengeApiClientProtocol

    init(challengeApiClient: ChallengeApiClientProtocol) {
        self.challengeApiClient = challengeApiClient
    }

    /*
    func agreeChallengePost(marketingConsentAgreed: Bool ) async throws {
        let result = await challengeApiClient.agreement(marketingConsentAgreed: marketingConsentAgreed)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }*/
}

