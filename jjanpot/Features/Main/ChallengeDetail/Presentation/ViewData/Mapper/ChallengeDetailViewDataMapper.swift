//
//  ChallengeDetailViewDataMapper.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//

import Foundation

struct ChallengeDetailViewDataMapper {
    func map (from entity: ChallengeDetailEntity) -> ChallengeDetailViewData {
        let targetAmount = formatWonRange(entity.goalAmount)
        let personTargetAmound = formatWonRange(entity.minPersonalGoalAmount)
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
        categories.map{$0.name}.joined(separator: ", ")
    }
    
    
    private func joinWithComma(_ array: [String]) -> String {
        return array.joined(separator: ", ")
    }
    
    private func formatWonRange(_ value: Int) -> String {
        if value < 10_000 {
            return "\(value)원"
        }
        
        let man = value / 10_000
        let remainder = value % 10_000
        
        if remainder == 0 {
            return "\(man)만원"
        } else {
            let thousand = remainder / 1_000
            return "\(man)만\(thousand)천원"
        }
    }
}
