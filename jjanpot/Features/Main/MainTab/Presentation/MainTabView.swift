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
        TabView (selection: $selectedTab) {

            // Home
            container.makeHomeView()
               
        }
    }
}

#Preview {
    MainTabView(container: MockMainDIContainer())
}
