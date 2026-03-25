//
//  LaunchScreenDIContainer.swift
//  jjanpot
//
//  Created by 임주희 on 3/22/26.
//


import Foundation

protocol LaunchScreenDIContainerProtocol {
    func makeLaunchScreenView(appCoordinator: AppCoordinator) -> LaunchScreenView
}

final class LaunchScreenDIContainer: LaunchScreenDIContainerProtocol {

    // MARK: - Dependencies

    private let authApiClient: AuthApiClientProtocol
    private let appContainer: AppDIContainer

    // MARK: - Initializer

    init(authApiClient: AuthApiClientProtocol, appContainer: AppDIContainer) {
        self.authApiClient = authApiClient
        self.appContainer = appContainer
    }

    // MARK: - Repository

    private func makeLaunchScreenRepository() -> LaunchScreenRepositoryProtocol {
        return LaunchScreenRepository(authApiClient: authApiClient)
    }

    // MARK: - ViewModel

    private func makeLaunchScreenViewModel(appCoordinator: AppCoordinator) -> LaunchScreenViewModel {
        let repository = makeLaunchScreenRepository()
        let useCase = LaunchScreenUseCase(repository: repository)
        return LaunchScreenViewModel(useCase: useCase, appCoordinator: appCoordinator)
    }

    // MARK: - View

    func makeLaunchScreenView(appCoordinator: AppCoordinator) -> LaunchScreenView {
        let viewModel = makeLaunchScreenViewModel(appCoordinator: appCoordinator)
        return LaunchScreenView(viewModel: viewModel)
    }
}
