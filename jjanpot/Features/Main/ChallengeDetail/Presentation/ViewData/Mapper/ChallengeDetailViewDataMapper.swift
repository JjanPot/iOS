//
//  ChallengeDetailViewDataMapper.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import Foundation

struct ChallengeDetailViewDataMapper {
    func map (from entity: ChallengeDetailEntity) -> ChallengeDetailViewData {
        let targetAmount = PriceFormatter.formatWon(entity.goalAmount)
        let personTargetAmound = PriceFormatter.formatWon(entity.minPersonalGoalAmount)
        let during = "\(entity.startDate.toString(.dateOnly2)) - \(entity.endDate.toString(.dateOnly2)) (1주)"
        
        return ChallengeDetailViewData(
            basicInfo: ChallengeBasicInfoViewData(
                teamName: entity.title,
                goals: "\(targetAmount) 목표로 1주동안 함께 절약하기",
                category: categories(entity.categories),
                teamTargetAmount: targetAmount,
                personTargetAmound: "\(personTargetAmound) 이상",
                relationshipType: entity.team.teamType,
                during: during,
                memberCount: "\(entity.team.maxMemberCount)명"
            ),
            description: entity.description,
            hasCancelButton: (entity.isLeader && entity.status.contains("대기중"))
        )
    }     
    
    private func categories(_ categories: [CategoryEntity]) -> String {
        let result = stride(from: 0, to: categories.count, by: 2)
            .map { i -> String in
                let pair = categories[i..<min(i+2, categories.count)]
                return pair
                    .map { "\($0.name) (\(PriceFormatter.formatWon($0.amount)))" }
                    .joined(separator: "  ")
            }
            .joined(separator: "\n")
        return result
    }
    
    
    private func joinWithComma(_ array: [String]) -> String {
        return array.joined(separator: ", ")
    }
}
