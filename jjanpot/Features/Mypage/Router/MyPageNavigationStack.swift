//
//  MyPageNavigationStack.swift
//  jjanpot
//
//  Created by Claude on 4/3/26.
//

import SwiftUI

/// MyPage의 독립적인 NavigationStack
struct MyPageNavigationStack: View {
    @StateObject private var coordinator: MyPageCoordinator

    private let container: MyPageDIContainerProtocol

    init(container: MyPageDIContainerProtocol) {
        self.container = container
        self._coordinator = StateObject(wrappedValue: container.makeMyPageCoordinator())
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            // MyPage (MyPot) 루트 화면
            container.makeMyPotView(coordinator: coordinator)
                .navigationDestination(for: MyPageDestination.self) { destination in
                    destinationView(for: destination)
                }
        }
    }

    @ViewBuilder
    private func destinationView(for destination: MyPageDestination) -> some View {
        // MyPage 내부 네비게이션이 필요하면 여기에 추가
        switch destination {
        // 케이스별 화면 추가
        default:
            EmptyView()
        }
    }
}

#Preview {
    MyPageNavigationStack(container: MockMyPageDIContainer())
}
