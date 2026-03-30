//
//  CreateChallengeResponseDto.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


struct CreateChallengeResponseDto: Codable {
    let challengeId: Int
    let teamId: Int
    let inviteCode: String
    let goalAmount, minPersonalGoalAmount: Int
    let startDate, endDate: String
    let categories: [ChallengeCategoryDto]
    
    enum CodingKeys: String, CodingKey {
        case challengeId
        case teamId
        case inviteCode, goalAmount, minPersonalGoalAmount, startDate, endDate, categories
    }
}
