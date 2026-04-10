//
//  ChallengeFeedViewDataMapper.swift
//  jjanpot
//
//  Created by 임주희 on 4/2/26.
//

import Foundation
import SwiftUI

struct ChallengeFeedViewDataMapper {
    func map(from entities: [FeedEntity]) -> [ChallengeFeedViewData] {
        var result: [ChallengeFeedViewData] = []
        var currentDate: String? = nil

        for entity in entities {
            // "2027.08.15"
            let dateString = entity.createdAt.toString(.dateOnly2,  locale: .kr)
            
            // 날짜가 바뀌면 header 추가
            if currentDate != dateString {
                result.append(.header(id: UUID(), date: dateString))
                currentDate = dateString
            }

            // 피드 아이템 추가
            let feedCard = FeedCardViewData(
                feedId: entity.certificationId,
                authorId: entity.certificationId,
                authorNickname: entity.userNickname,
                category: entity.categoryName,
                content: entity.memo ?? "",
                price: "\(entity.savedAmount > 0 ? "+" : "")\(entity.savedAmount)원",
                likeCount: entity.likeCount,
                date: entity.createdAt.toString(.dateTime2, locale: .kr),
                imageUrl: entity.imageURL,
                isMine: entity.isMe
            )
            result.append(.item(id: UUID(), feed: feedCard))
        }

        // 마지막에 bottom 추가
        if !entities.isEmpty {
            result.append(.bottom(id: UUID()))
        }

        return result
    }
}
