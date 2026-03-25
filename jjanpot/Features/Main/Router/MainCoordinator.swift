//
//  MainCoordinator.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI
import Combine

enum MainDestination: Route {
    // TODO: Main 플로우의 화면들을 여기에 추가
    // 예: case profile, case settings, case detail(id: String) 등

    // 임시로 추가 - 실제 화면 추가 시 제거하고 사용하세요
    case placeholder

    var id: String {
        switch self {
        case .placeholder:
            return "placeholder"
        }
    }

    var analyticsName: String {
        switch self {
        case .placeholder:
            return "main_placeholder"
        }
    }

    var hidesTabBar: Bool {
        // Main 플로우에서 특정 화면은 탭바를 숨길 수 있음
        switch self {
        case .placeholder:
            return false
        }
    }
}

@MainActor
final class MainCoordinator: ObservableObject {
    @Published var path = NavigationPath()

    init() {}

    // MARK: - Navigation Methods

    /// 특정 화면으로 이동
    func push(_ destination: MainDestination) {
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
