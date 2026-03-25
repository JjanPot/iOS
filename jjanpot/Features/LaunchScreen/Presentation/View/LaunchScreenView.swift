//
//  LaunchScreenView.swift
//  jjanpot
//
//  Created by 임주희 on 3/25/26.
//

import SwiftUI

/// 앱 시작 시 토큰 체크를 수행하는 로딩 화면
struct LaunchScreenView: View {
    @StateObject private var viewModel: LaunchScreenViewModel

    init(viewModel: LaunchScreenViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea()

            Image("LaunchImage")
        }
        .task {
            // 토큰 갱신 + 유저 정보 가져오기
            viewModel.checkAuth()
        }
    }
}

#Preview {
    let coordinator = AppCoordinator()
    let container = AppDIContainer.shared
    return container.makeLaunchScreenView(appCoordinator: coordinator)
}
