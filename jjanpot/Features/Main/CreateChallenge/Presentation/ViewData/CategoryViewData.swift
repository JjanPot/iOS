//
//  CategoryViewData.swift
//  jjanpot
//
//  Created by 임주희 on 3/30/26.
//

import Foundation

struct CategoryViewData: GridDisplayable {
    let id: Int // categoryId
    let name: String
    let nameUS: String
    let iconURL: String?
    let amountOptions: [Int]

    var displayTitle: String { name }

    var displayImage: String? {
        // 서버에서 받은 iconURL 기반으로 로컬 이미지 매핑
        // 또는 추후 서버 이미지 URL 사용
        switch id {
        case 1: return "icon_category_food"
        case 2: return "icon_category_cafe"
        case 3: return "icon_category_car"
        case 4: return "icon_category_fashion"
        case 5: return "icon_category_hobby"
        case 6: return "icon_category_bear"
        case 7: return "icon_category_etc"
        default: return nil
        }
    }

    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: CategoryViewData, rhs: CategoryViewData) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Mapper

extension CategoryViewData {
    init(from entity: CategoryEntity) {
        
        let krName: String
        switch entity.name {
        case "FOOD_DELIVERY": krName = "외식/배달"
        case "CAFE_DESSERT": krName =  "카페/디저트"
        case "TRANSPORT": krName =  "교통"
        case "FASHION_BEAUTY": krName =  "패션/뷰티"
        case "HOBBY_CULTURE": krName =  "취미/문화"
        case "ALCOHOL_ENTERTAINMENT": krName =  "술/유흥"
        case "OTHER": krName =  "기타"
        default: krName = ""
        }
        
        self.id = entity.categoryId
        self.nameUS = entity.name
        self.name = krName
        self.iconURL = entity.iconURL
        self.amountOptions = entity.amountOptions
    }
}
