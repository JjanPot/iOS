//
//  SavingCategoryDto.swift
//  jjanpot
//
//  Created by 임주희 on 3/30/26.
//

import Foundation

// 절약항목 (챌린지 상세화면 절약항목)
struct SavingCategoryDto: Codable {
    let categoryId: Int
    let name: String
    let iconURL: String?
    let amountOptions: [Int]

    enum CodingKeys: String, CodingKey {
        case categoryId 
        case name
        case iconURL = "iconUrl"
        case amountOptions
    }
}



