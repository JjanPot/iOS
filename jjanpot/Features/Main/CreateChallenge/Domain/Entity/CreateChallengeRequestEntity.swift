//
//  CreateChallengeRequestEntity.swift
//  jjanpot
//
//  Created by 임주희 on 3/30/26.
//

import Foundation

// 서버에 보내는 용
struct CreateChallengeRequestEntity {
    let title: String
    let description: String
    let teamType: String
    let maxMemberCount: Int
    let startDate: Date
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
        
        // 날짜 포맷
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDateString = dateFormatter.string(from: startDate)

        
        let dtoCategories = categories.map {
            ChallengeCategoryDto(id: $0.categoryId, amount: $0.amount)
        }

        return CreateChallengeRequestDto(
            title: title,
            description: description,
            teamType: teamType,
            maxMemberCount: maxMemberCount,
            startDate: startDateString,
            categories: dtoCategories,
            goalAmount: goalAmount,
            minPersonalGoalAmount: minPersonalGoalAmount
        )
    }
    
    
}
