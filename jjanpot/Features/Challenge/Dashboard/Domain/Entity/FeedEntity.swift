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
    let userNickname: String
    let memo: String?
    let savedAmount: Int
    let imageURL: String?
    let createdAt: String
    let likeCount: Int
}
extension FeedEntity {
    init(from dto: FeedResponseDto) {
        self.certificationId = dto.certificationId
        self.spendType = dto.spendType
        self.categoryName = dto.categoryName
        self.userNickname = dto.userNickname
        self.memo = dto.memo
        self.savedAmount = dto.savedAmount
        self.imageURL = dto.imageURL
        self.createdAt = dto.createdAt
        self.likeCount = dto.likeCount
    }
}
