//
//  Route.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import Foundation

/// 네비게이션 Route의 공통 인터페이스
/// 각 도메인의 Destination은 이 프로토콜을 채택하여 타입 안정성과 메타데이터 관리를 제공합니다.
protocol Route: Hashable {
    /// Route의 고유 식별자
    var id: String { get }

    /// 애널리틱스 추적을 위한 화면 이름
    var analyticsName: String { get }

    /// 스와이프 백 제스처 비활성화 여부
    var disableSwipeBack: Bool { get }

    /// 탭바 숨김 여부
    var hidesTabBar: Bool { get }
}

// MARK: - Default Implementation

extension Route {
    /// 기본적으로 스와이프 백 허용
    var disableSwipeBack: Bool { false }

    /// 기본적으로 탭바 유지
    var hidesTabBar: Bool { false }
}
