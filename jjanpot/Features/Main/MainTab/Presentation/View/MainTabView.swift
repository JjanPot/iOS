//
//  MainTabView.swift
//  jjanpot
//
//  Created by 임주희 on 3/24/26.
//

import SwiftUI

struct MainTabView: View {
    @State var selectedTab: Int = 0
    private let container: MainDIContainerProtocol

    init(container: MainDIContainerProtocol) {
        self.container = container
    }

    var body: some View {
        VStack(spacing: .zero){
            TabView (selection: $selectedTab) {
                
                // Home
                container.makeHomeView()
                    .tag(0)
                    
                
                // 챌린지
                EmptyView()
                
                // 마이팟
                EmptyView()
                    .tag(2)
                
            } //TabView
            .hideTabBar()
            
            // 커스텀 탭바 [홈 | 챌린지 | 마이팟]
            MainTabBar(selectedTab: $selectedTab)
                .ignoresSafeArea(edges: .bottom)
                
        } //VStack
        
    }
}

#Preview {
    MainTabView(container: MockMainDIContainer())
}
