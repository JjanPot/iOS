//
//  LikesEntity.swift
//  jjanpot
//
//  Created by 임주희 on 5/11/26.
//

import Foundation

struct LikesEntity {
    let isLiked: Bool
    let likeCount: Int
}
extension LikesEntity {
    init(from dto: LikesDto) {
        self.isLiked = dto.isLiked
        self.likeCount = dto.likeCount
    }
}
