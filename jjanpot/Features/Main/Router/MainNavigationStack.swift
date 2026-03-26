//
//  MainNavigationStack.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

/// 메인 플로우의 독립적인 NavigationStack
/// App 레벨에서 분기되어 메인 관련 화면들을 관리합니다.
struct MainNavigationStack: View {
    @StateObject private var coordinator: MainCoordinator

    private let container: MainDIContainerProtocol

    init(container: MainDIContainerProtocol = AppDIContainer.shared.mainDIContainer) {
        self.container = container
        _coordinator = StateObject(wrappedValue: container.makeMainCoordinator())
    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            // 메인 탭 화면
            container.makeMainTabView()
                .navigationDestination(for: MainDestination.self) { destination in
                    switch destination {
                    case .placeholder:
                        // 임시 placeholder - 실제 화면 추가 시 제거하세요
                        Text("Placeholder View")
                    // TODO: 각 destination에 따른 화면 구현
                    // 예:
                    // case .profile:
                    //     container.makeProfileView()
                    // case .settings:
                    //     container.makeSettingsView()
                    }
                }
        }
    }
}

#Preview {
    MainNavigationStack()
}
