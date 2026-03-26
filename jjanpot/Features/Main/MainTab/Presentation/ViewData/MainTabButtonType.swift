//
//  MainTabButtonType.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


enum MainTabButtonType {
    case home
    case challenge
    case mypot
    
    
    var iconName: String {
        switch self {
            
        case .home:
            "navi_home"
        case .challenge:
            "navi_challenge"
        case .mypot:
            "navi_mypot"
        }
    }
    
    var selectedIconName: String {
        switch self {
            
        case .home:
            "navi_home_fill"
        case .challenge:
            "navi_challenge_fill"
        case .mypot:
            "navi_mypot_fill"
        }
    }
    
    var buttonName: String {
        switch self {
        case .home:
            "홈"
        case .challenge:
            "챌린지"
        case .mypot:
            "마이팟"
        }
    }
}
