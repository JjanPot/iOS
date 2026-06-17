//
//  ChallengeReportDto.swift
//  jjanpot
//
//  Created by 임주희 on 4/5/26.
//


struct ChallengeReportDto: Codable {
    let isTeamSuccess: Bool
    let goalAmount, totalSavedAmount, achievementRate: Int
    let categoryNames: [String]
    let personalSavedAmount: Int
}
