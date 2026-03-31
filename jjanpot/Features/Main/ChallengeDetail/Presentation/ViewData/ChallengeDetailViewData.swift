//
//  ChallengeDetailViewData.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


/*
    private let viewData = ChallengeDetailViewData(
        teamName: "배달을 아껴요",
        goals: "30만원 목표로 1주동안 함께 절약하기",
        category: "외식/배달",
        teamTargetAmount: "30만원",
        personTargetAmound: "2만원 이상",
        relationshipType: "친구",
        during: "26.07.15-26.07.15",
        memberCount: "5명",
        description: "배달을 아끼는 챌린지 방입니다. 모두 절약 파이팅"
    )
*/

struct ChallengeDetailViewData {
    let teamName: String
    let goals: String
    let category: String
    let teamTargetAmount: String
    let personTargetAmound: String
    let relationshipType: String
    let during: String
    let memberCount: String
    
    // 챌린지 설명
    let description: String
}

struct ChallengeDetailViewDataMapper {
    func map (from entity: ChallengeDetailEntity) -> ChallengeDetailViewData {
        let targetAmount = formatWonRange(entity.goalAmount)
        let personTargetAmound = formatWonRange(entity.minPersonalGoalAmount)
        let during = "\(entity.startDate.toString(.dateOnly2)) - \(entity.endDate.toString(.dateOnly2)) (1주)"
        
        return ChallengeDetailViewData(
            teamName: entity.title,
            goals: "\(targetAmount) 목표로 1주동안 함께 절약하기",
            category: categories(entity.categories),
            teamTargetAmount: targetAmount,
            personTargetAmound: "\(personTargetAmound) 이상",
            relationshipType: entity.team.teamType,
            during: during,
            memberCount: "\(entity.team.maxMemberCount)명",
            description: entity.description
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
