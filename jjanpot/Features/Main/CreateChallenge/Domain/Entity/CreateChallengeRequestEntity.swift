//
//  CreateChallengeRequestEntity.swift
//  jjanpot
//
//  Created by 임주희 on 3/30/26.
//

import Foundation

struct CreateChallengeRequestEntity {
    let title: String
    let description: String
    let teamType: String
    let maxMemberCount: Int
    let startDate: String
    let categories: [CategoryWithAmount]
    let goalAmount: Int
    let minPersonalGoalAmount: Int

    struct CategoryWithAmount {
        let categoryId: Int
        let amount: Int
    }
}

// MARK: - Mapper

extension CreateChallengeRequestEntity {
    func toDTO() -> CreateChallengeRequestDto {
        let dtoCategories = categories.map {
            CreateChallengeRequestDto.Category(id: $0.categoryId, amount: $0.amount)
        }

        return CreateChallengeRequestDto(
            title: title,
            description: description,
            teamType: teamType,
            maxMemberCount: maxMemberCount,
            startDate: startDate,
            categories: dtoCategories,
            goalAmount: goalAmount,
            minPersonalGoalAmount: minPersonalGoalAmount
        )
    }
}
