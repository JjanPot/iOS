//
//  MyChallengeStatsItemView.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//


import SwiftUI

struct MyChallengeStatsItemView : View {
    enum ViewType {
        case totalChallenge
        case success
        case failed
        case successRate
        
        var image: String {
            switch self {
            case .totalChallenge:
                return "cup"
            case .success:
                return "smile"
            case .failed:
                return "sad"
            case .successRate:
                return "fire"
            }
        }
        
        var title: String {
            switch self {
            case .totalChallenge:
                return "총 챌린지"
            case .success:
                return "성공"
            case .failed:
                return "실패"
            case .successRate:
                return "성공률"
            }
        }
    }
    let viewType: ViewType
    let content: String
    init(_ viewType: ViewType, content: String) {
        self.viewType = viewType
        self.content = content
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Image(viewType.image)
                .frame(width: 30, height: 30)
            
            Text(viewType.title)
                .font(.pretendard(.regular, size: 12))
                .foregroundStyle(.black600)
            Text(content)
                .font(.pretendard(.semiBold, size: 20))
                .foregroundStyle(.black)
        }
        
    }
    
}
