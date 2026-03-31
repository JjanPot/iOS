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

    /// API 요청에 사용되는 문자열 값
    var apiValue: String {
        switch self {
        case .friend: return "FRIEND"
        case .partner: return "COUPLE"
        case .family: return "FAMILY"
        case .community: return "CLUB"
        case .etc: return "OTHER"
        }
    }
}
