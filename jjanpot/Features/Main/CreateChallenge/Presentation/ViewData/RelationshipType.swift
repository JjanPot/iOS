//
//  RelationshipType.swift
//  jjanpot
//
//  Created by 임주희 on 3/28/26.
//


enum RelationshipType: SelectableGridItem {
    case friend      // 친구
    case partner     // 연인
    case family      // 가족
    case community   // 소모임
    case etc

    var title: String {
        switch self {
        case .friend: return "친구"
        case .partner: return "연인"
        case .family: return "가족"
        case .community: return "소모임"
        case .etc: return "기타"
        }
    }
    
    var image: String? {
        return nil
    }
}
