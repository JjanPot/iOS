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

    // 홈 화면
    func makeHomeView(coordinator: MainCoordinator) -> HomeView

    // 초대 코드 화면
    func makeInviteCodePopupView(inviteCode: String?, onCloseAction: @escaping ()-> Void ) -> InviteCodePopupView

    // 챌린지 생성 화면
    func makeCreateChallengeView() -> CreateChallengeView
    
    // 챌린지 상세정보 화면
    func makeChallengeDetailView() -> ChallengeDetailView

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

    func makeHomeView(coordinator: MainCoordinator) -> HomeView {
        let viewModel = makeHomeViewModel()
        return HomeView(viewModel: viewModel, coordinator: coordinator)
    }
    
    // MARK: - InviteCode

    private func makeInviteCodeViewModel() -> InviteCodePopupViewModel {
        return InviteCodePopupViewModel()
    }

    func makeInviteCodePopupView(inviteCode: String?, onCloseAction: @escaping ()-> Void ) -> InviteCodePopupView {
        let vm = makeInviteCodeViewModel()
        return InviteCodePopupView(viewModel: vm, inviteCode: inviteCode, onCloseAction: { onCloseAction() })
    }
    
    // MARK: - 챌린지 생성 화면
    func makeCreateChallengeView() -> CreateChallengeView {
        CreateChallengeView()
    }
    
    // MARK: - 챌린지 상세정보 화면
    func makeChallengeDetailView() -> ChallengeDetailView {
        ChallengeDetailView()
    }
}

// MARK: - Mock

final class MockMainDIContainer: MainDIContainerProtocol {
    func makeMainCoordinator() -> MainCoordinator {
        return MainCoordinator()
    }

    func makeHomeView(coordinator: MainCoordinator) -> HomeView {
        let useCase = MockHomeUseCase()
        let viewModel = HomeViewModel(useCase: useCase)
        return HomeView(viewModel: viewModel, coordinator: coordinator)
    }
    
    
    func makeCreateChallengeView() -> CreateChallengeView {
        CreateChallengeView()
    }
    
    final class MockHomeUseCase: HomeUseCaseProtocol {
        func fetchChallengeData() async throws -> HomeEntity {
            throw NetworkError.dataNil
        }
        func fetchHomeData() async throws -> HomeEntity{
            throw NetworkError.dataNil
        }
    }
    
    func makeInviteCodePopupView(inviteCode: String?, onCloseAction: @escaping ()-> Void ) -> InviteCodePopupView {
        let vm = InviteCodePopupViewModel()
        return InviteCodePopupView(viewModel: vm, inviteCode: inviteCode, onCloseAction: {onCloseAction()})
    }
    
    func makeChallengeDetailView() -> ChallengeDetailView {
        ChallengeDetailView()
    }
}


