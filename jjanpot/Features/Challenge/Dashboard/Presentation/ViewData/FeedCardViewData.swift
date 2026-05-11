//
//  FeedCardViewData.swift
//  jjanpot
//
//  Created by 임주희 on 4/2/26.
//

import Foundation

struct FeedCardViewData {
    let feedId: Int
    
    
    // feed 작성자 유저 id
    let authorId: Int
    let authorNickname: String
    
    let category: String
    let content: String
    let price: String
    
    let likeCount: Int
    //    let isLiked: Bool
    
    let date: String
    let imageUrl: String?
    
    let isMine: Bool
    
}
extension FeedCardViewData {
    func withUpdatedLikeCount(_ count: Int) -> FeedCardViewData {
        FeedCardViewData(
            feedId: self.feedId,
            authorId: self.authorId,
            authorNickname: self.authorNickname,
            category: self.category,
            content: self.content,
            price: self.price,
            likeCount: count,
            date: self.date,
            imageUrl: self.imageUrl,
            isMine: self.isMine
        )
    }
}

