//
//  ChallengePostRepository.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import Foundation
import UIKit

struct ChallengePostRepository: ChallengePostRepositoryProtocol {
    private let apiClient: ChallengeApiClientProtocol

    init(challengeApiClient: ChallengeApiClientProtocol) {
        self.apiClient = challengeApiClient
    }


    func fetchDetail(challengeId: Int) async throws -> ChallengeDetailEntity {
        let result = await apiClient.fetchDetail(challengeId: challengeId)

        switch result {
        case .success(let dto):
            return ChallengeDetailEntity(from: dto)
        case .failure(let error):
            throw error
        }
    }

    func postChallenge(entity: ChallengePostRequestEntity, imageData: Data?) async throws {
        let dto = ChallengePostRequestDto(from: entity)
        let result = await apiClient.postChallenge(dto: dto, imageData: imageData)

        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}
