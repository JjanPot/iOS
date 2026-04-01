//
//  FeedResponseDto.swift
//  jjanpot
//
//  Created by 임주희 on 4/2/26.
//

import Foundation

struct FeedResponseDto: Codable {
    let certificationId: Int
    let spendType, categoryName, userNickname, memo: String
    let savedAmount: Int
    let imageURL: String
    let createdAt: String
    let likeCount: Int

    enum CodingKeys: String, CodingKey {
        case certificationId
        case spendType, categoryName, userNickname, memo, savedAmount
        case imageURL = "imageUrl"
        case createdAt, likeCount
    }
}
