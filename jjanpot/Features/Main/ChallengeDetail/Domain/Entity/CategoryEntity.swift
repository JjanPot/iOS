//
//  CategoryEntity.swift
//  jjanpot
//
//  Created by 임주희 on 3/30/26.
//

import Foundation

// 상세정보 카테고리
struct CategoryEntity {
    let categoryId: Int
    let name: String
    let iconURL: String?
    // 기준금액
    let amount: Int
}

// MARK: - Mapper

extension CategoryEntity {
    init(from dto: ChallengeDetailResponseDto.Category) {
        self.categoryId = dto.categoryId
        self.name = dto.name
        self.iconURL = dto.iconUrl
        self.amount = dto.amount
    }
}
