//
//  OverviewEntity.swift
//  jjanpot
//
//  Created by 임주희 on 4/2/26.
//


import Foundation


struct OverviewEntity {
    let challengeId: Int
    let title: String
    let startDate: Date
    let totalSavedAmount, goalAmount: Int
    let members: [Member]
    
    // MARK: - Member
    struct Member  {
        let userId: Int
        let nickname: String
        let profileImageURL: String?
        let savedAmount: Int
        let isMe: Bool
        let isLeader: Bool
        let isBlocked: Bool
    }
}
extension OverviewEntity {
    init(from dto: OverviewDto) {
        self.challengeId = dto.challengeId
        self.title = dto.title
        self.startDate = dto.startDate.toDate(.iso8601) ?? Date()
        self.totalSavedAmount = dto.totalSavedAmount
        self.goalAmount = dto.goalAmount
        self.members = dto.members.map{ OverviewEntity.Member(from: $0) }
    }
}
extension OverviewEntity.Member {
    init(from dto: OverviewDto.Member){
        self.userId = dto.userId
        self.nickname = dto.nickname
        self.profileImageURL = dto.profileImageURL
        self.savedAmount = dto.savedAmount
        self.isMe = dto.isMe
        self.isBlocked = dto.isBlocked
        self.isLeader = dto.role == .leader
    }
}


