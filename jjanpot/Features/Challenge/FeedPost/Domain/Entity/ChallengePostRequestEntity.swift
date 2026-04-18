//
//  FeedPostRequestEntity.swift
//  jjanpot
//
//  Created by 임주희 on 4/2/26.
//

import Foundation

struct FeedPostRequestEntity {
    let challengeId: Int
    let spendType: String
    let categoryId: Int
    let spentAmount: Int?
    let memo: String
    /// "2026-03-29T10:30:00"
    let spentAt: Date
}
