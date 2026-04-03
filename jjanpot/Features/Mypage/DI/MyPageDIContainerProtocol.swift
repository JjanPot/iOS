//
//  MyPageDIContainerProtocol.swift
//  jjanpot
//
//  Created by Claude on 4/3/26.
//

import Foundation
import SwiftUI
import Alamofire

protocol MyPageDIContainerProtocol {
    func makeMyPageCoordinator() -> MyPageCoordinator
    func makeMyPotView(coordinator: MyPageCoordinator) -> MyPotView
    func makeSettingsView(coordinator: MyPageCoordinator) -> SettingsView
}

final class MyPageDIContainer: MyPageDIContainerProtocol {

    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }

    // MARK: - Coordinator

    func makeMyPageCoordinator() -> MyPageCoordinator {
        return MyPageCoordinator(container: self)
    }

    // MARK: - MyPage (MyPot)

    private func makeMyPotRepository() -> MyPotRepositoryProtocol {
        return MyPotRepository(authApiClient: authApiClient)
    }

    private func makeMyPotUseCase() -> MyPotUseCaseProtocol {
        let repo = makeMyPotRepository()
        return MyPotUseCase(repository: repo)
    }

    private func makeMyPotViewModel() -> MyPotViewModel {
        let usecase = makeMyPotUseCase()
        return MyPotViewModel(useCase: usecase)
    }

    func makeMyPotView(coordinator: MyPageCoordinator) -> MyPotView {
        let vm = makeMyPotViewModel()
        return MyPotView(viewModel: vm, coordinator: coordinator)
    }
    
    // MARK: - 설정화면
    
    private func makeSettingsRepository() -> SettingsRepositoryProtocol {
        return SettingsRepository(authApiClient: authApiClient)
    }
    private func makeSettingsUseCase() -> SettingsUseCaseProtocol {
        let repo = makeSettingsRepository()
        return SettingsUseCase(repository: repo)
    }
    private func makeSettingsViewModel() -> SettingsViewModel {
        let usecase = makeSettingsUseCase()
        return SettingsViewModel(useCase: usecase)
    }
    
    func makeSettingsView(coordinator: MyPageCoordinator) -> SettingsView {
        let vm = makeSettingsViewModel()
        return SettingsView(viewModel: vm, coordinator: coordinator)
    }
}

// MARK: - Mock

final class MockMyPageDIContainer: MyPageDIContainerProtocol {

    func makeMyPageCoordinator() -> MyPageCoordinator {
        return MyPageCoordinator(container: self)
    }

    func makeMyPotView(coordinator: MyPageCoordinator) -> MyPotView {
        let vm = MyPotViewModel(useCase: MockMyPotUseCase())
        return MyPotView(viewModel: vm, coordinator: coordinator)
    }

    struct MockMyPotUseCase: MyPotUseCaseProtocol {
        func logout() async throws {
            throw NetworkError.dataNil
        }
    }
    
    func makeSettingsView(coordinator: MyPageCoordinator) -> SettingsView {
        let usecase = MockSettingsUseCase()
        let vm = SettingsViewModel(useCase: usecase)
        return SettingsView(viewModel: vm, coordinator: coordinator)
    }
    struct MockSettingsUseCase: SettingsUseCaseProtocol {
        
    }
}
