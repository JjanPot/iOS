//
//  ChallengeStatsEntity.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//

import Foundation

struct ChallengeStatsEntity {
    let totalCount, successCount, failCount, successRate: Int
}
extension ChallengeStatsEntity {
    init(from dto: ChallengeStatsDto ) {
        self.totalCount = dto.totalCount
        self.successCount = dto.successCount
        self.failCount = dto.failCount
        self.successRate = dto.successRate
    }
}

struct MyStatsViewData {
    
    let totalCount, successCount, failCount, successRate: String
}
extension MyStatsViewData {
    init(from entity: ChallengeStatsEntity ){
        self.totalCount = "\(entity.totalCount)"
        self.successCount = "\(entity.successCount)"
        self.failCount = "\(entity.failCount)"
        self.successRate = "\(entity.successRate)%"
    }
}
