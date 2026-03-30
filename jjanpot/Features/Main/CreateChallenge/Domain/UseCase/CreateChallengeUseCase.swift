//
//  CreateChallengeUseCase.swift
//  jjanpot
//
//  Created by 임주희 on 3/30/26.
//

import Foundation

protocol CreateChallengeUseCaseProtocol {
    func getCategories() async throws -> [SavingCategoryEntity]
    
    func createChallenge(
        title: String,
        description: String,
        teamType: String,
        maxMemberCount: Int,
        startDate: Date,
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

    func getCategories() async throws -> [SavingCategoryEntity] {
        return try await repository.getCategories()
    }

    func createChallenge(
        title: String,
        description: String,
        teamType: String,
        maxMemberCount: Int,
        startDate: Date,
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
