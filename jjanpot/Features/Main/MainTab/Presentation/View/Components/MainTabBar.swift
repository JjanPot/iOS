//
//  MainTabBar.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//

import Foundation
import SwiftUI

// 커스텀 탭바
struct MainTabBar: View {
    
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            
            // MARK: 홈
            TabButton(
                type: .home,
                isSelected: selectedTab == 0) {
                selectedTab = 0
            }
            
            // MARK: 챌린지
            TabButton(
                type: .challenge,
                isSelected: selectedTab == 1) {
                selectedTab = 1
            }
            
            // MARK: 마이팟
            TabButton(
                type: .mypot,
                isSelected: selectedTab == 2) {
                selectedTab = 2
            }
        }
        .frame(height: 43)
        .padding(.top, 16)
        .background(
            ZStack {
                Color.white
                    .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))

                Color.white
                    .clipShape(RoundedCorner(radius: 10, corners: [.topLeft, .topRight]))
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -2)
                    .mask(
                        Rectangle()
                            .padding(.top, -20)
                    )
            }
        )


        // Safe Area 영역 채우기
//        Color.gray900
//            .frame(height: geometry.safeAreaInsets.bottom)
    }
}



#Preview{
    MainTabBar(selectedTab: .constant(0))
    MainTabBar(selectedTab: .constant(1))
    MainTabBar(selectedTab: .constant(2))
}
