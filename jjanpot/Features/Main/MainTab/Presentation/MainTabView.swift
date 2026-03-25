//
//  MainTabView.swift
//  jjanpot
//
//  Created by 임주희 on 3/24/26.
//

import SwiftUI

struct MainTabView: View {
    @State var selectedTab: Int = 0
    var body: some View {
        TabView (selection: $selectedTab) {
            
            // Home
            
            // 챌린지
            
            // 마이팟
        }
    }
}

#Preview {
    MainTabView()
}
