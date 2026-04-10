//
//  FeedResponseDto.swift
//  jjanpot
//
//  Created by 임주희 on 4/2/26.
//

import Foundation

struct FeedResponseDto: Codable {
    let certificationId: Int
    let userId: Int
    let spendType, categoryName, userNickname: String
    let memo: String?
    let savedAmount: Int
    let imageURL: String?
    /// "2027-08-15T09:35:00"
    let createdAt: String
    let likeCount: Int
    let isMe: Bool

    enum CodingKeys: String, CodingKey {
        case certificationId, userId
        case spendType, categoryName, userNickname, memo, savedAmount
        case imageURL = "imageUrl"
        case createdAt, likeCount, isMe
    }
}
