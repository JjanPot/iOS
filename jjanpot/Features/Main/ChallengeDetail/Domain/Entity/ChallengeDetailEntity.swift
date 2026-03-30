//
//  ChallengeDetailEntity.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//

import Foundation

struct ChallengeDetailEntity {
    let challengeId: Int
    let title: String
    let description: String
    let status: String
    
    let goalAmount: Int
    let minPersonalGoalAmount: Int
    let startDate: Date
    let endDate: Date
    let categories: [CategoryEntity]
    let team: Team
    let isLeader: Bool
    
    struct Team: Codable {
        let teamId: Int
        let inviteCode: String
        let currentMemberCount: Int
        let maxMemberCount: Int
        let teamType: String
    }
}


// MARK: - Mapper

extension ChallengeDetailEntity {
    init(from dto: ChallengeDetailResponseDto) {
        self.challengeId = dto.challengeId
        self.title = dto.title
        self.description = dto.description
        self.status = dto.status
        self.goalAmount = dto.goalAmount
        self.minPersonalGoalAmount = dto.minPersonalGoalAmount
        self.startDate = dto.startDate.toDate(.iso8601) ?? Date()
        self.endDate = dto.endDate.toDate(.iso8601) ?? Date()
        self.categories = dto.categories.map { CategoryEntity(from: $0)}
        self.team = ChallengeDetailEntity.Team(from: dto.team)
        self.isLeader = dto.isLeader
    }
}
extension ChallengeDetailEntity.Team {
    init(from dto: ChallengeDetailResponseDto.Team)  {
        self.teamId = dto.teamId
        self.inviteCode = dto.inviteCode
        self.currentMemberCount = dto.currentMemberCount
        self.maxMemberCount = dto.maxMemberCount
        self.teamType = dto.teamType
    }
}
