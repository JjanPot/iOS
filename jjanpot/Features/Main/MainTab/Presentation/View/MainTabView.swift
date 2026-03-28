//
//  MainTabView.swift
//  jjanpot
//
//  Created by 임주희 on 3/24/26.
//

import SwiftUI

struct MainTabView: View {
    @State var selectedTab: Int = 0

    private let homeView: AnyView
    private let challengeView: AnyView
    private let myPotView: AnyView

    init(
        homeView: AnyView,
        challengeView: AnyView,
        myPotView: AnyView
    ) {
        self.homeView = homeView
        self.challengeView = challengeView
        self.myPotView = myPotView
    }

    var body: some View {
        VStack(spacing: .zero){
            TabView (selection: $selectedTab) {

                // Home
                homeView
                    .tag(0)

                // 챌린지
                challengeView
                    .tag(1)

                // 마이팟
                myPotView
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
    let container = MockMainDIContainer()
    let coordinator = MainCoordinator()
    return MainTabView(
        homeView: AnyView(container.makeHomeView(coordinator: coordinator)),
        challengeView: AnyView(ContentView()),
        myPotView: AnyView(ContentView2())
    )
}
