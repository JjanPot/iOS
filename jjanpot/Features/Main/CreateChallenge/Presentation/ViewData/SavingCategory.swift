//
//  SavingCategory.swift
//  jjanpot
//
//  Created by 임주희 on 3/29/26.
//


enum SavingCategory: SelectableGridItem, Identifiable {
    var id: Self { self }
    case food
    case cafe
    case car
    case fasion
    case hobby
    case bear
    case other

    var title: String {
        switch self {
        case .food:
            return "외식/배달"
        case .cafe:
            return "카페/디저트"
        case .car:
            return "교통"
        case .fasion:
            return "패션/뷰티"
        case .hobby:
            return "취미/문화"
        case .bear:
            return "술/유흥"
        case .other:
            return "기타"
        }
    }

    var image: String? {
        switch self {
        case .food:
            return "icon_category_food"
        case .cafe:
            return "icon_category_cafe"
        case .car:
            return "icon_category_car"
        case .fasion:
            return "icon_category_fashion"
        case .hobby:
            return "icon_category_hobby"
        case .bear:
            return "icon_category_bear"
        case .other:
            return "icon_category_etc"
        }
    }

    /*
    /// API 요청에 사용되는 카테고리 ID
    var categoryId: Int {
        switch self {
        case .food: return 1
        case .cafe: return 2
        case .car: return 3
        case .fasion: return 4
        case .hobby: return 5
        case .bear: return 6
        case .other: return 7
        }
    }
     */
}
