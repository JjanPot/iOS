//
//  CategorySelectorViewData.swift
//  jjanpot
//
//  Created by 임주희 on 4/16/26.
//


struct CategorySelectorViewData: Identifiable {
    //categoryId
    let id: Int
    let name: String
    let icon: String
    // 기준금액
    let amount: Int
}

extension CategorySelectorViewData {
    init(from entity: CategoryEntity) {
        
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
        self.name =  entity.name
        self.icon = imageName
        self.amount = entity.amount
    }
}
