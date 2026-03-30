//
//  CategoryEntity.swift
//  jjanpot
//
//  Created by 임주희 on 3/30/26.
//

import Foundation

struct CategoryEntity {
    let categoryId: Int
    let name: String
    let iconURL: String?
    let amountOptions: [Int]
}

// MARK: - Mapper

extension CategoryEntity {
    init(from dto: CategoryDto) {
        self.categoryId = dto.categoryId
        self.name = dto.name
        self.iconURL = dto.iconURL
        self.amountOptions = dto.amountOptions
    }
}
