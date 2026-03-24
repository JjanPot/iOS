//
//  LaunchScreenView.swift
//  jjanpot
//
//  Created by 임주희 on 3/22/26.
//

import SwiftUI

struct LaunchScreenView: View {
    @StateObject private var viewModel: LaunchScreenViewModel
    private let container: AppDIContainer
    
    init(viewModel: LaunchScreenViewModel, container: AppDIContainer) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.container = container
    }
    
    
    var body: some View {
        switch viewModel.navigationDestination {
        case .loading:
            ZStack {
                Color.white
                    .ignoresSafeArea()

                Image("LaunchImage")
            }
            .task {
                // 토큰 갱신 + 유저 정보 가져오기
                viewModel.checkAuth()
            }

        case .main:
            // 인증 성공 → 메인 화면
            container.makeMainTabView()

        case .login:
            // 인증 실패 → 로그인 화면
            container.makeLoginView(onDismiss: {
                // 로그인 성공 (기존 유저) → 메인 화면으로 root 변경
                viewModel.navigationDestination = .main
            })
        }
    }
}

#Preview {
    AppDIContainer.shared.makeLaunchScreenView()
}
