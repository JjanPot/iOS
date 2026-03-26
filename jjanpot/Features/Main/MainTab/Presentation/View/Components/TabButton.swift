//
//  TabButton.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import SwiftUI

struct TabButton: View {
    let type: MainTabButtonType
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 1) {
                // 아이콘
                Image(isSelected ? type.selectedIconName : type.iconName)
                    .resizable()
                    .frame(width: 24, height: 24)
                
                
                // 이름
                Text(type.buttonName)
                    .font(.pretendard(.medium, size: 12))
                    .foregroundStyle(isSelected ? .orange500 : .black300)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    TabButton(type: .home, isSelected: false, action: {})
    TabButton(type: .home, isSelected: true, action: {})
}
