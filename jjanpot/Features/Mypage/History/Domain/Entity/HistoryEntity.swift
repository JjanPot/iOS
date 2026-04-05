//
//  HistoryEntity.swift
//  jjanpot
//
//  Created by 임주희 on 4/5/26.
//


import Foundation
import SwiftUI

struct HistoryEntity {
    let challengeId: Int
    let title: String
    let status: String
    let statusDisplayName: String
    let goalAmount: Int
    let startDate: Date
    let endDate: Date
}
extension HistoryEntity {
    init(from dto: ChallengeHistoryDto) {
        self.challengeId = dto.challengeId
        self.title = dto.title
        self.status = dto.status
        self.statusDisplayName = dto.statusDisplayName
        self.goalAmount = dto.goalAmount
        self.startDate = dto.startDate.toDate(.iso8601) ?? Date()
        self.endDate = dto.endDate.toDate(.iso8601) ?? Date()
    }
}

