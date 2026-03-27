//
//  MainDIContainerProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import Foundation
import SwiftUI
import Alamofire

protocol MainDIContainerProtocol {
    func makeMainCoordinator() -> MainCoordinator

    // 메인 탭 화면
    func makeMainTabView() -> MainTabView

    // 홈 화면
    func makeHomeView() -> HomeView
}

final class MainDIContainer: MainDIContainerProtocol {
    
    private let challengeApiClient: ChallengeApiClientProtocol

          init(session: Session) {
              self.challengeApiClient = ChallengeApiClient(session: session)
          }
    
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
        return HomeRepository(apiClient: challengeApiClient)
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
        
        let useCase = MockHomeUseCase()
        let viewModel = HomeViewModel(useCase: useCase)
        return HomeView(viewModel: viewModel)
    }
    
    final class MockHomeUseCase: HomeUseCaseProtocol {
        func fetchChallengeData() async throws -> HomeEntity {
            throw NetworkError.dataNil
        }
        func fetchHomeData() async throws -> HomeEntity{
            throw NetworkError.dataNil
        }
    }
}


