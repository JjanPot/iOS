//
//  MyPageCoordinator.swift
//  jjanpot
//
//  Created by Claude on 4/3/26.
//

import SwiftUI
import Combine

enum MyPageDestination: Route {
    // MyPage 내부 네비게이션이 필요하면 여기에 추가
    
    case settings

    var id: String {
        switch self {
        // 케이스별 id 추가
        case .settings: return "settings"
        }
    }

    var analyticsName: String {
        switch self {
        // 케이스별 analyticsName 추가
        case .settings: return "settings"
        }
    }

    var hidesTabBar: Bool {
        switch self {
        // 케이스별 hidesTabBar 추가
        case .settings: return false
        }
    }
}

@MainActor
final class MyPageCoordinator: ObservableObject {
    private let container: MyPageDIContainerProtocol
    @Published var path = NavigationPath()

    init(container: MyPageDIContainerProtocol) {
        self.container = container
    }

    // MARK: - Navigation Methods

    /// 특정 화면으로 이동
    func push(_ destination: MyPageDestination) {
        path.append(destination)
    }

    /// 이전 화면으로 돌아가기
    func pop() {
        guard !path.isEmpty else { return }
        path.removeLast()
    }

    /// 특정 개수만큼 뒤로 가기
    func pop(count: Int) {
        guard path.count >= count else { return }
        path.removeLast(count)
    }

    /// 네비게이션 스택 초기화 (루트로 이동)
    func popToRoot() {
        path = NavigationPath()
    }
}
