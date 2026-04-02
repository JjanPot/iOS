//
//  MyPotRepository.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//


struct MyPotRepository: MyPotRepositoryProtocol {
    private let challengeApiClient: ChallengeApiClientProtocol

    init(challengeApiClient: ChallengeApiClientProtocol) {
        self.challengeApiClient = challengeApiClient
    }

    /*
    func agreeMyPot(marketingConsentAgreed: Bool ) async throws {
        let result = await challengeApiClient.agreement(marketingConsentAgreed: marketingConsentAgreed)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }*/
}
