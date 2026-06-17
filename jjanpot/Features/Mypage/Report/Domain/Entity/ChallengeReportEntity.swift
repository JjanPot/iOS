//
//  ChallengeReportEntity.swift
//  jjanpot
//
//  Created by 임주희 on 4/5/26.
//


struct ChallengeReportEntity: Codable {
    let isTeamSuccess: Bool
    let goalAmount: Int
    let totalSavedAmount: Int
    let achievementRate: Int
    let categoryNames: [String]
    let personalSavedAmount: Int
}
extension ChallengeReportEntity {
    init(from dto: ChallengeReportDto)  {
        self.isTeamSuccess = dto.isTeamSuccess
        self.goalAmount = dto.goalAmount
        self.totalSavedAmount = dto.totalSavedAmount
        self.achievementRate = dto.achievementRate
        self.categoryNames = dto.categoryNames
        self.personalSavedAmount = dto.personalSavedAmount
    }
}



