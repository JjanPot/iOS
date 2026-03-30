//
//  ChallengeDetailResponseDto.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//

import Foundation

struct ChallengeDetailResponseDto: Codable {
    let challengeId: Int
    let title, description, status: String
    let goalAmount, minPersonalGoalAmount: Int
    let startDate, endDate: String
    let categories: [Category]
    let team: Team
    let isLeader: Bool

    enum CodingKeys: String, CodingKey {
        case challengeId
        case title, description, status, goalAmount, minPersonalGoalAmount, startDate, endDate, categories, team, isLeader
    }
    
    struct Team: Codable {
        let teamId: Int
        let inviteCode: String
        let currentMemberCount, maxMemberCount: Int
        let teamType: String

        enum CodingKeys: String, CodingKey {
            case teamId
            case inviteCode, currentMemberCount, maxMemberCount, teamType
        }
    }
    
    struct Category: Codable {
        let categoryId: Int
        let name: String
        let iconUrl: String?
        let amount: Int
        
        enum CodingKeys: String, CodingKey {
            case name = "categoryName"
            case categoryId, iconUrl, amount
        }
    }

}

