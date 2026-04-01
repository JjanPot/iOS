//
//  SavingCategoryViewData.swift
//  jjanpot
//
//  Created by 임주희 on 3/30/26.
//

import Foundation

// 챌린지 생성하기 절약항목
struct SavingCategoryViewData: GridDisplayable {
    let id: Int // categoryId
    let name: String
    let nameUS: String
    //let iconURL: String?
    let iconName: String
    let amountOptions: [Int]

    var displayTitle: String { name }

    var displayImage: String? {
        return iconName
    }

    // Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: SavingCategoryViewData, rhs: SavingCategoryViewData) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Mapper

extension SavingCategoryViewData {
    init(from entity: SavingCategoryEntity) {
        
        let krName: String
        switch entity.name {
        case "FOOD_DELIVERY": krName = "외식/배달"
        case "CAFE_DESSERT": krName =  "카페/디저트"
        case "TRANSPORT": krName =  "교통"
        case "FASHION_BEAUTY": krName =  "패션/뷰티"
        case "HOBBY_CULTURE": krName =  "취미/문화"
        case "ALCOHOL_ENTERTAINMENT": krName =  "술/유흥"
        case "OTHER": krName = "기타"
        default: krName = ""
        }
        
        let imageName: String
        switch entity.name {
        case "FOOD_DELIVERY": imageName = "icon_category_food"
        case "CAFE_DESSERT": imageName = "icon_category_cafe"
        case "TRANSPORT": imageName = "icon_category_car"
        case "FASHION_BEAUTY": imageName = "icon_category_fashion"
        case "HOBBY_CULTURE": imageName = "icon_category_hobby"
        case "ALCOHOL_ENTERTAINMENT": imageName = "icon_category_bear"
        case "OTHER": imageName = "icon_category_etc"
        default: imageName = ""
        }
        
        self.id = entity.categoryId
        self.nameUS = entity.name
        self.name = krName
        self.iconName = imageName
        self.amountOptions = entity.amountOptions
    }
}
