//
//  CreateChallengeUseCase.swift
//  jjanpot
//
//  Created by 임주희 on 3/30/26.
//

import Foundation

protocol CreateChallengeUseCaseProtocol {
    func fetchCategories() async throws -> [CategoryEntity]
    
    func createChallenge(
        title: String,
        description: String,
        teamType: String,
        maxMemberCount: Int,
        startDate: String,
        categories: [CreateChallengeRequestEntity.CategoryWithAmount],
        goalAmount: Int,
        minPersonalGoalAmount: Int
    ) async throws -> CreateChallengeEntity
}

final class CreateChallengeUseCase: CreateChallengeUseCaseProtocol {
    private let repository: CreateChallengeRepositoryProtocol

    init(repository: CreateChallengeRepositoryProtocol) {
        self.repository = repository
    }

    func fetchCategories() async throws -> [CategoryEntity] {
        return try await repository.fetchCategories()
    }

    func createChallenge(
        title: String,
        description: String,
        teamType: String,
        maxMemberCount: Int,
        startDate: String,
        categories: [CreateChallengeRequestEntity.CategoryWithAmount],
        goalAmount: Int,
        minPersonalGoalAmount: Int
    ) async throws -> CreateChallengeEntity {
        // Entity 생성
        let entity = CreateChallengeRequestEntity(
            title: title,
            description: description,
            teamType: teamType,
            maxMemberCount: maxMemberCount,
            startDate: startDate,
            categories: categories,
            goalAmount: goalAmount,
            minPersonalGoalAmount: minPersonalGoalAmount
        )

        return try await repository.createChallenge(entity: entity)
    }
}
