//
//  FoodEstimatedSavingAmount.swift
//  jjanpot
//
//  Created by 임주희 on 3/29/26.
//


// MARK:  카테고리별 금액 선택 Enums

enum FoodEstimatedSavingAmount: SelectableGridItem {
    case _10000
    case _15000
    case _20000
    case _30000

    var title: String {
        switch self {
        case ._10000: return "10,000원"
        case ._15000: return "15,000원"
        case ._20000: return "20,000원"
        case ._30000: return "30,000원"
        }
    }
    var image: String? { nil }

    var rawValue: Int {
        switch self {
        case ._10000: return 10000
        case ._15000: return 15000
        case ._20000: return 20000
        case ._30000: return 30000
        }
    }
}

enum CafeEstimatedSavingAmount: SelectableGridItem {
    case _1500
    case _2000
    case _4000
    case _7000

    var title: String {
        switch self {
        case ._1500: return "1,500원"
        case ._2000: return "2,000원"
        case ._4000: return "4,000원"
        case ._7000: return "7,000원"
        }
    }
    var image: String? { nil }

    var rawValue: Int {
        switch self {
        case ._1500: return 1500
        case ._2000: return 2000
        case ._4000: return 4000
        case ._7000: return 7000
        }
    }
}

enum CarEstimatedSavingAmount: SelectableGridItem {
    case _1500
    case _3000
    case _5000
    case _10000

    var title: String {
        switch self {
        case ._1500: return "1,500원"
        case ._3000: return "3,000원"
        case ._5000: return "5,000원"
        case ._10000: return "10,000원"
        }
    }
    var image: String? { nil }

    var rawValue: Int {
        switch self {
        case ._1500: return 1500
        case ._3000: return 3000
        case ._5000: return 5000
        case ._10000: return 10000
        }
    }
}

enum FashionEstimatedSavingAmount: SelectableGridItem {
    case _10000
    case _30000
    case _50000
    case _100000


    var title: String {
        switch self {
        case ._10000: return "10,000원"
        case ._30000: return "30,000원"
        case ._50000: return "50,000원"
        case ._100000: return "100,000원"

        }
    }
    var image: String? { nil }

    var rawValue: Int {
        switch self {
        case ._10000: return 10000
        case ._30000: return 30000
        case ._50000: return 50000
        case ._100000: return 100000
        }
    }
}

enum HobbyEstimatedSavingAmount: SelectableGridItem {
    case _5000
    case _10000
    case _20000
    case _50000

    var title: String {
        switch self {
        case ._5000: return "5,000원"
        case ._10000: return "10,000원"
        case ._20000: return "20,000원"
        case ._50000: return "50,000원"
        }
    }
    var image: String? { nil }

    var rawValue: Int {
        switch self {
        case ._5000: return 5000
        case ._10000: return 10000
        case ._20000: return 20000
        case ._50000: return 50000
        }
    }
}

enum BearEstimatedSavingAmount: SelectableGridItem {
    case _5000
    case _10000
    case _20000
    case _30000

    var title: String {
        switch self {
        case ._5000: return "5,000원"
        case ._10000: return "10,000원"
        case ._20000: return "20,000원"
        case ._30000: return "30,000원"
        }
    }
    var image: String? { nil }

    var rawValue: Int {
        switch self {
        case ._5000: return 5000
        case ._10000: return 10000
        case ._20000: return 20000
        case ._30000: return 30000
        }
    }
}

enum OtherEstimatedSavingAmount: SelectableGridItem {
    case _5000
    case _10000
    case _20000

    var title: String {
        switch self {
        case ._5000: return "5,000원"
        case ._10000: return "10,000원"
        case ._20000: return "20,000원"
        }
    }
    var image: String? { nil }

    var rawValue: Int {
        switch self {
        case ._5000: return 5000
        case ._10000: return 10000
        case ._20000: return 20000
        }
    }
}
