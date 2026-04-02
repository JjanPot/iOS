//
//  MainDIContainerProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import Foundation
import SwiftUI
import Alamofire

/*
 1. 모든 의존성을 생성하는 Factory
 2. Coordinator도 의존성이므로 DIContainer에서 생성
 3. self를 Coordinator에 주입해서 Coordinator가 다른 화면들을 만들 수 있게 함
 
 흐름
 
 App Start
 ↓
 DIContainer 생성
 ↓
 DIContainer.makeCoordinator() 호출
 ↓
 Coordinator(container: self) 생성
 ↓
 Coordinator가 container를 통해 View들을 생성
 */

protocol MainDIContainerProtocol {
    func makeMainCoordinator() -> MainCoordinator
    
    // 홈 화면
    func makeHomeView(coordinator: MainCoordinator) -> HomeView
    
    // 초대 코드 화면
    func makeInviteCodePopupView(inviteCode: String?, onCloseAction: @escaping ()-> Void ) -> InviteCodePopupView
    
    // 챌린지 생성 화면
    func makeCreateChallengeView(coordinator: MainCoordinator) -> CreateChallengeView
    
    // 챌린지 상세정보 화면
    func makeChallengeDetailView(challengeId: Int) -> ChallengeDetailView
    
    /// 챌린지 대시보드화면
    func makeChallengeDashboardView(coordinator: MainCoordinator) -> ChallengeDashboardView
    
    /// 지출,무지출 인증
    func makeChallengePostView(challengeId: Int, coordinator: MainCoordinator) -> ChallengePostView 
    
}

final class MainDIContainer: MainDIContainerProtocol {
    
    private let challengeApiClient: ChallengeApiClientProtocol
    
    init(session: Session) {
        self.challengeApiClient = ChallengeApiClient(session: session)
    }
    
    // MARK: - Coordinator
    
    func makeMainCoordinator() -> MainCoordinator {
        return MainCoordinator(container: self)
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
    
    private func makeInviteCodePopupRepository() -> InviteCodePopupRepositoryProtocol {
        return InviteCodePopupRepository(challengeApiClient: challengeApiClient)
    }
    private func makeInviteCodePopupUseCase() -> InviteCodePopupUseCaseProtocol {
        let repo = makeInviteCodePopupRepository()
        return InviteCodePopupUseCase(repository: repo)
    }
    private func makeInviteCodeViewModel() -> InviteCodePopupViewModel {
        let usecase = makeInviteCodePopupUseCase()
        return InviteCodePopupViewModel(useCase: usecase)
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
    
    private func makeChallengeDetailRepository() -> ChallengeDetailRepositoryProtocol {
        return ChallengeDetailRepository(apiClient: challengeApiClient)
    }
    
    private func makeChallengeDetailUseCase() -> ChallengeDetailUseCaseProtocol {
        let repo = makeChallengeDetailRepository()
        return ChallengeDetailUseCase(repository: repo)
    }
    
    private func makeChallengeDetailViewModel(challengeId: Int) -> ChallengeDetailViewModel {
        let useCase = makeChallengeDetailUseCase()
        return ChallengeDetailViewModel(challengeId: challengeId, useCase: useCase)
    }
    func makeChallengeDetailView(challengeId: Int) -> ChallengeDetailView {
        let vm = makeChallengeDetailViewModel(challengeId: challengeId)
        return ChallengeDetailView(viewModel: vm)
    }
    
    // MARK: - 챌린지 대시보드
    
    private func makeChallengeDashboardRepository() -> ChallengeDashboardRepositoryProtocol {
        return ChallengeDashboardRepository(challengeApiClient: challengeApiClient)
    }
    private func makeChallengeDashboardUseCase() -> ChallengeDashboardUseCaseProtocol {
        let repo = makeChallengeDashboardRepository()
        return ChallengeDashboardUseCase(repository: repo)
    }
    private func makeChallengeDashboardViewModel() -> ChallengeDashboardViewModel {
        let usecase = makeChallengeDashboardUseCase()
        return ChallengeDashboardViewModel(useCase: usecase)
    }
    
    func makeChallengeDashboardView(coordinator: MainCoordinator) -> ChallengeDashboardView {
        let vm = makeChallengeDashboardViewModel()
        return ChallengeDashboardView(viewModel: vm, coordinator: coordinator)
    }
    
    
    
    // MARK: - 지출, 무지출 인증화면
    
    private func makeChallengePostRepository() -> ChallengePostRepositoryProtocol {
        return ChallengePostRepository(challengeApiClient: challengeApiClient)
    }
    private func makeChallengePostUseCase() -> ChallengePostUseCaseProtocol {
        let repo = makeChallengePostRepository()
        return ChallengePostUseCase(repository: repo)
    }
    private func makeChallengePostViewModel(challengeId: Int) -> ChallengePostViewModel {
        let usecase = makeChallengePostUseCase()
        return ChallengePostViewModel(challengeId: challengeId, useCase: usecase)
    }
    
    func makeChallengePostView(challengeId: Int, coordinator: MainCoordinator) -> ChallengePostView {
        let vm = makeChallengePostViewModel(challengeId: challengeId)
        return ChallengePostView(viewModel: vm, coordinator: coordinator)
    }
}

// MARK: - Mock

final class MockMainDIContainer: MainDIContainerProtocol {
    
    func makeInviteCodePopupView(inviteCode: String?, onCloseAction: @escaping ()-> Void ) -> InviteCodePopupView {
        let vm = InviteCodePopupViewModel(useCase: MockInviteCodePopupUseCase())
        return InviteCodePopupView(viewModel: vm, inviteCode: inviteCode, onCloseAction: { onCloseAction() })
    }
    
    func makeMainCoordinator() -> MainCoordinator {
        return MainCoordinator(container: self)
    }
    
    func makeHomeView(coordinator: MainCoordinator) -> HomeView {
        let useCase = MockHomeUseCase()
        let viewModel = HomeViewModel(useCase: useCase)
        return HomeView(viewModel: viewModel, coordinator: coordinator)
    }
    
    func makeCreateChallengeView(coordinator: MainCoordinator) -> CreateChallengeView {
        let useCase = MockCreateChallengeUseCase()
        let viewModel = CreateChallengeViewModel(useCase: useCase)
        return CreateChallengeView(viewModel: viewModel, coordinator: coordinator)
    }
    
    func makeChallengeDetailView(challengeId: Int) -> ChallengeDetailView {
        let usecase = MockChallengeDetailUseCase()
        let vm = ChallengeDetailViewModel(challengeId: challengeId, useCase: usecase)
        return ChallengeDetailView(viewModel: vm)
    }
    
    func makeChallengeDashboardView(coordinator: MainCoordinator) -> ChallengeDashboardView {
        let usecase = MockChallengeDashboardUseCase()
        let vm = ChallengeDashboardViewModel(useCase: usecase)
        return ChallengeDashboardView(viewModel: vm, coordinator: coordinator)
    }
    
    
    func makeChallengePostView(challengeId: Int, coordinator: MainCoordinator) -> ChallengePostView {
        let usecase = MockChallengePostUseCase()
        let viewModel = ChallengePostViewModel(challengeId: challengeId, useCase: usecase)
        return ChallengePostView(viewModel: viewModel, coordinator: coordinator)
    }
    
    final class MockChallengeDetailUseCase: ChallengeDetailUseCaseProtocol {
        func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity {
            throw NetworkError.dataNil
        }
    }
    
    final class MockHomeUseCase: HomeUseCaseProtocol {
        func fetchChallengeData() async throws -> HomeEntity {
            throw NetworkError.dataNil
        }
        func fetchHomeData() async throws -> HomeEntity{
            throw NetworkError.dataNil
        }
    }
    final class MockCreateChallengeUseCase: CreateChallengeUseCaseProtocol {
        func getCategories() async throws -> [SavingCategoryEntity] {
            throw NetworkError.dataNil
        }
        
        func createChallenge(title: String, description: String, teamType: String, maxMemberCount: Int, startDate: Date, categories: [CreateChallengeRequestEntity.CategoryWithAmount], goalAmount: Int, minPersonalGoalAmount: Int) async throws -> CreateChallengeEntity {
            throw NetworkError.dataNil
        }
    }
    struct MockInviteCodePopupUseCase: InviteCodePopupUseCaseProtocol {
        func submitInviteCode(code: String) async throws {
            throw NetworkError.dataNil
        }
    }
    struct MockChallengeDashboardUseCase: ChallengeDashboardUseCaseProtocol {
        func getChallengeDashboardData() async throws -> ChallengeDashboardEntity {
            throw NetworkError.dataNil
        }
    }
    struct MockChallengePostUseCase: ChallengePostUseCaseProtocol {
        func postChallenge(entity: ChallengePostRequestEntity, image: UIImage?) async throws {
            throw NetworkError.dataNil
        }
        
        func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity {
            throw NetworkError.dataNil
        }
    }
}


