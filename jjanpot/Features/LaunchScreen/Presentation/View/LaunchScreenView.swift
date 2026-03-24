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
        if viewModel.isLaunchFinished {
            // 할 일 완료 후 메인 화면으로 전환
            container.makeLoginView(onDismiss: {})
        } else {
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
}

#Preview {
    AppDIContainer.shared.makeLaunchScreenView()
}
