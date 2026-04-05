//
//  ChallengeHistoryDto.swift
//  jjanpot
//
//  Created by 임주희 on 4/5/26.
//


struct ChallengeHistoryDto: Codable {
    let challengeId: Int
    let title, status, statusDisplayName: String
    let goalAmount: Int
    let startDate, endDate: String

    enum CodingKeys: String, CodingKey {
        case challengeId
        case title, status, statusDisplayName, goalAmount, startDate, endDate
    }
}
