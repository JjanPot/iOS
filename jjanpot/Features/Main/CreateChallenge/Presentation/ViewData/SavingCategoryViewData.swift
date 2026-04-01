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
        switch entity.categoryId {
        case 1: krName = "외식/배달"
        case 2: krName =  "카페/디저트"
        case 3: krName =  "교통"
        case 4: krName =  "패션/뷰티"
        case 5: krName =  "취미/문화"
        case 6: krName =  "술/유흥"
        case 7: krName = "기타"
        default: krName = ""
        }
        
        let imageName: String
        switch entity.categoryId {
        case 1: imageName = "icon_category_food"
        case 2: imageName = "icon_category_cafe"
        case 3: imageName = "icon_category_car"
        case 4: imageName = "icon_category_fashion"
        case 5: imageName = "icon_category_hobby"
        case 6: imageName = "icon_category_bear"
        case 7: imageName = "icon_category_etc"
        default: imageName = ""
        }
        
        self.id = entity.categoryId
        self.nameUS = entity.name
        self.name = krName
        self.iconName = imageName
        self.amountOptions = entity.amountOptions
    }
}
