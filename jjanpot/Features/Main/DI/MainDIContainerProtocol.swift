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
    func makeCreateChallengeView(coordinator: MainCoordinator) -> CreateChallengeView

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

    private func makeCreateChallengeRepository() -> CreateChallengeRepositoryProtocol {
        return CreateChallengeRepository(apiClient: challengeApiClient)
    }

    private func makeCreateChallengeUseCase() -> CreateChallengeUseCaseProtocol {
        return CreateChallengeUseCase(repository: makeCreateChallengeRepository())
    }

    private func makeCreateChallengeViewModel() -> CreateChallengeViewModel {
        return CreateChallengeViewModel(useCase: makeCreateChallengeUseCase())
    }

    func makeCreateChallengeView(coordinator: MainCoordinator) -> CreateChallengeView {
        let viewModel = makeCreateChallengeViewModel()
        return CreateChallengeView(viewModel: viewModel, coordinator: coordinator)
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
    
    
    func makeCreateChallengeView(coordinator: MainCoordinator) -> CreateChallengeView {
        let repository = MockCreateChallengeRepository()
        let useCase = CreateChallengeUseCase(repository: repository)
        let viewModel = CreateChallengeViewModel(useCase: useCase)
        return CreateChallengeView(viewModel: viewModel, coordinator: coordinator)
    }

    final class MockHomeUseCase: HomeUseCaseProtocol {
        func fetchChallengeData() async throws -> HomeEntity {
            throw NetworkError.dataNil
        }
        func fetchHomeData() async throws -> HomeEntity{
            throw NetworkError.dataNil
        }
    }

    final class MockChallengeApiClient: ChallengeApiClientProtocol {
        func fetchChallenges() async -> Result<ChallengeResponseDto, NetworkError> {
            .failure(.dataNil)
        }

        func fetchChallengeSummary(challengeId: Int) async -> Result<ChallengeSummaryDto, NetworkError> {
            .failure(.dataNil)
        }

        func fetchCategories() async -> Result<[CategoryDto], NetworkError> {
            .failure(.dataNil)
        }

        func createChallenge(dto: CreateChallengeRequestDto) async -> Result<CreateChallengeResponseDto, NetworkError> {
            // Mock 성공 응답
            try? await Task.sleep(nanoseconds: 1_000_000_000) // 1초 delay
            return .success(CreateChallengeResponseDto())
        }
    }

    final class MockCreateChallengeRepository: CreateChallengeRepositoryProtocol {
        func fetchCategories() async throws -> [CategoryEntity] {
            // Mock 카테고리 데이터
            return [
                CategoryEntity(categoryId: 1, name: "외식/배달", iconURL: nil, amountOptions: [10000, 15000, 20000, 30000]),
                CategoryEntity(categoryId: 2, name: "카페/디저트", iconURL: nil, amountOptions: [1500, 2000, 4000, 7000]),
                CategoryEntity(categoryId: 3, name: "교통", iconURL: nil, amountOptions: [1500, 3000, 5000, 10000]),
                CategoryEntity(categoryId: 4, name: "패션/뷰티", iconURL: nil, amountOptions: [10000, 30000, 50000, 100000]),
                CategoryEntity(categoryId: 5, name: "취미/문화", iconURL: nil, amountOptions: [5000, 10000, 20000, 50000]),
                CategoryEntity(categoryId: 6, name: "술/유흥", iconURL: nil, amountOptions: [5000, 10000, 20000, 30000]),
                CategoryEntity(categoryId: 7, name: "기타", iconURL: nil, amountOptions: [5000, 10000, 20000])
            ]
        }

        func createChallenge(entity: CreateChallengeRequestEntity) async throws -> CreateChallengeEntity {
            // Mock 성공 응답
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            return CreateChallengeEntity()
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


