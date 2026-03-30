//
//  CategoryDto.swift
//  jjanpot
//
//  Created by 임주희 on 3/30/26.
//

import Foundation

struct CategoryDto: Codable {
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
