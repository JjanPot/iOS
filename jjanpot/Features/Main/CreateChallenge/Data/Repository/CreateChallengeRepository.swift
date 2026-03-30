//
//  CreateChallengeRepository.swift
//  jjanpot
//
//  Created by 임주희 on 3/30/26.
//

import Foundation

final class CreateChallengeRepository: CreateChallengeRepositoryProtocol {
    private let apiClient: ChallengeApiClientProtocol

    init(apiClient: ChallengeApiClientProtocol) {
        self.apiClient = apiClient
    }

    func fetchCategories() async throws -> [CategoryEntity] {
        let result = await apiClient.fetchCategories()

        switch result {
        case .success(let dtos):
            return dtos.map { CategoryEntity(from: $0) }
        case .failure(let error):
            throw error
        }
    }

    func createChallenge(entity: CreateChallengeRequestEntity) async throws -> CreateChallengeEntity {
        // Entity → DTO 변환
        let dto = entity.toDTO()

        let result = await apiClient.createChallenge(dto: dto)

        switch result {
        case .success(let responseDto):
            return CreateChallengeEntity(from: responseDto)
        case .failure(let error):
            throw error
        }
    }
}
