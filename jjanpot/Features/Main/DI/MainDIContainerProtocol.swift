//
//  MainDIContainerProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import Foundation
import SwiftUI

protocol MainDIContainerProtocol {
    func makeMainCoordinator() -> MainCoordinator

    // 메인 탭 화면
    func makeMainTabView() -> MainTabView

    // 홈 화면
    func makeHomeView() -> HomeView

    // 초대 코드 화면
    func makeInviteCodeView(hasSkip: Bool) -> InviteCodeView
}

final class MainDIContainer: MainDIContainerProtocol {

    // MARK: - Coordinator

    func makeMainCoordinator() -> MainCoordinator {
        return MainCoordinator()
    }

    // MARK: - MainTab

    func makeMainTabView() -> MainTabView {
        return MainTabView(container: self)
    }

    // MARK: - Home

    private func makeHomeRepository() -> HomeRepositoryProtocol {
        return HomeRepository()
    }

    private func makeHomeUseCase() -> HomeUseCaseProtocol {
        return HomeUseCase(repository: makeHomeRepository())
    }

    private func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(useCase: makeHomeUseCase())
    }

    func makeHomeView() -> HomeView {
        let viewModel = makeHomeViewModel()
        return HomeView(viewModel: viewModel)
    }

    // MARK: - InviteCode

    private func makeInviteCodeViewModel() -> InviteCodeViewModel {
        return InviteCodeViewModel()
    }

    func makeInviteCodeView(hasSkip: Bool = true) -> InviteCodeView {
        let vm = makeInviteCodeViewModel()
        return InviteCodeView(viewModel: vm, hasSkip: hasSkip)
    }
}

// MARK: - Mock

final class MockMainDIContainer: MainDIContainerProtocol {

    func makeMainCoordinator() -> MainCoordinator {
        return MainCoordinator()
    }

    func makeMainTabView() -> MainTabView {
        return MainTabView(container: self)
    }

    func makeHomeView() -> HomeView {
        let repository = HomeRepository()
        let useCase = HomeUseCase(repository: repository)
        let viewModel = HomeViewModel(useCase: useCase)
        return HomeView(viewModel: viewModel)
    }

    func makeInviteCodeView(hasSkip: Bool = true) -> InviteCodeView {
        return InviteCodeView(viewModel: InviteCodeViewModel(), hasSkip: hasSkip)
    }
}


