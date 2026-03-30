//
//  SavingCategoryEntity.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


// 절약항목 (챌린지 상세화면 절약항목)
struct SavingCategoryEntity {
    let categoryId: Int
    let name: String
    let iconURL: String?
    let amountOptions: [Int]
}

extension SavingCategoryEntity {
    init(from dto: SavingCategoryDto) {
        self.categoryId = dto.categoryId
        self.name = dto.name
        self.iconURL = dto.iconURL
        self.amountOptions = dto.amountOptions
    }
}
