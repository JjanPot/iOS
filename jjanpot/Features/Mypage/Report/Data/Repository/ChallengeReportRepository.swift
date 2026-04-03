//
//  ChallengeReportRepository.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//

import Foundation

struct ChallengeReportRepository: ChallengeReportRepositoryProtocol {
    private let challengeApiClient: ChallengeApiClientProtocol

    init(challengeApiClient: ChallengeApiClientProtocol) {
        self.challengeApiClient = challengeApiClient
    }

    /*
    func agree<#name#>(marketingConsentAgreed: Bool ) async throws {
        let result = await challengeApiClient.agreement(marketingConsentAgreed: marketingConsentAgreed)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }*/
}


