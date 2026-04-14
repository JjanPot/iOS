//
//  FeedResponseEntity.swift
//  jjanpot
//
//  Created by 임주희 on 4/2/26.
//

import Foundation

struct FeedEntity {
    let certificationId: Int
    let spendType: String
    let categoryName: String
    let userId: Int
    let userNickname: String
    let memo: String?
    let savedAmount: Int
    let imageURL: String?
    let createdAt: Date
    let likeCount: Int
    let isMe: Bool
}
extension FeedEntity {
    init(from dto: FeedResponseDto) {
        self.certificationId = dto.certificationId
        self.spendType = dto.spendType
        self.categoryName = dto.categoryName
        self.userId = dto.userId
        self.userNickname = dto.userNickname
        self.memo = dto.memo
        self.savedAmount = dto.savedAmount
        self.imageURL = dto.imageURL
        /// "2027-08-15T09:35:00"
        self.createdAt = dto.createdAt.toDate(.iso8601WithMicroseconds) ?? Date()
        self.likeCount = dto.likeCount
        self.isMe = dto.isMe
    }
}
extension FeedEntity: Identifiable, Equatable, Hashable {
    var id: Int {
        certificationId
    }
}
