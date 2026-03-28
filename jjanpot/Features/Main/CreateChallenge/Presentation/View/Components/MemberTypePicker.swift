//
//  MemberTypePicker.swift
//  jjanpot
//
//  Created by 임주희 on 3/28/26.
//

import SwiftUI


enum RelationshipType: CaseIterable {
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
}

struct MemberTypePicker: View {
    
    @Binding var selectedType: RelationshipType? 
    
    // 3열 고정 레이아웃
        let columns = [
            GridItem(.flexible(), spacing: 5),
            GridItem(.flexible(), spacing: 5),
            GridItem(.flexible(), spacing: 5)
        ]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 5) {
                    ForEach(RelationshipType.allCases, id: \.self) { type in
                        Button(action: { selectedType = type }) {
                            Text(type.title)
                                .font(.pretendard(.medium, size: 12))
                                // 너비를 꽉 채우되, GridItem에 의해 1/3 크기로 고정됨
                                .frame(maxWidth: .infinity)
                                .frame(height: 37)
                                .background(Color.white)
                                .foregroundColor(.black900)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(selectedType == type ? Color.orange500 : Color.black100, lineWidth: 1)
                                )
                        }
                    }
                }
    }
}

#Preview {
    MemberTypePicker(selectedType: .constant(nil))
}
