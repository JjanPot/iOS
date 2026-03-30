//
//  CreateChallengeRequestDto.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//

import Foundation


struct CreateChallengeRequestDto: Codable {
    let title, description, teamType: String
    let maxMemberCount: Int
    
    /// "2026-03-18"
    let startDate: String
    let categories: [ChallengeCategoryDto]
    
    let goalAmount, minPersonalGoalAmount: Int
}


struct ChallengeCategoryDto: Codable {
    let id: Int
    let amount: Int

    enum CodingKeys: String, CodingKey {
        case id = "categoryId"
        case amount
    }
}
