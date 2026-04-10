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
    
    let category: String
    let title: String
    let content: String
    let price: String
    let likeCount: Int
    let date: String
    let imageUrl: String?
    
    let isMine: Bool
}
