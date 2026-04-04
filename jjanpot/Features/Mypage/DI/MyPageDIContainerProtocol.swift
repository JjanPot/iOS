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
    
    /// 마이페이지 (마이팟)
    func makeMyPotView(coordinator: MyPageCoordinator) -> MyPotView
    
    /// 설정화면
    func makeSettingsView(coordinator: MyPageCoordinator) -> SettingsView
    
    /// 알람 설정
    func makeAlarmSettingsView() -> AlarmSettingsView
    
    /// 챌린지 결과
    func makeChallengeReportView(challengeId: Int, coordinator: MyPageCoordinator) -> ChallengeReportView
}

final class MyPageDIContainer: MyPageDIContainerProtocol {

    private let authApiClient: AuthApiClientProtocol
    private let challengeApiClient: ChallengeApiClientProtocol

    init(authApiClient: AuthApiClientProtocol, challengeApiClient: ChallengeApiClientProtocol) {
        self.authApiClient = authApiClient
        self.challengeApiClient = challengeApiClient
    }

    // MARK: - Coordinator

    func makeMyPageCoordinator() -> MyPageCoordinator {
        return MyPageCoordinator(container: self)
    }

    // MARK: - MyPage (MyPot)

    private func makeMyPotRepository() -> MyPotRepositoryProtocol {
        return MyPotRepository(authApiClient: authApiClient, challengeApiClient: challengeApiClient)
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
    
    func makeAlarmSettingsView() -> AlarmSettingsView {
        let vm = makeSettingsViewModel()
        return AlarmSettingsView(viewModel: vm)
    }
    
    // MARK: - 챌린지 결과화면
    
    private func makeChallengeReportRepository() -> ChallengeReportRepositoryProtocol {
        return ChallengeReportRepository(challengeApiClient: challengeApiClient)
    }
    private func makeChallengeReportUseCase() -> ChallengeReportUseCaseProtocol {
        let repo = makeChallengeReportRepository()
        return ChallengeReportUseCase(repository: repo)
    }
    private func makeChallengeReportViewModel(challengeId: Int) -> ChallengeReportViewModel {
        let usecase = makeChallengeReportUseCase()
        return ChallengeReportViewModel(challengeId: challengeId, useCase: usecase)
    }
    
    func makeChallengeReportView(challengeId: Int, coordinator: MyPageCoordinator) -> ChallengeReportView {
        let vm = makeChallengeReportViewModel(challengeId: challengeId)
        return ChallengeReportView(viewModel: vm, coordinator: coordinator)
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
        func getUserInfo() async throws -> UserEntity {
            UserEntity(userId: 3, nickname: "주희희", imageUrl: "https://picsum.photos/100/100")
        }
        
        func getMyChallengeStats() async throws -> ChallengeStatsEntity {
            ChallengeStatsEntity(totalCount: 10, successCount: 3, failCount: 7, successRate: 10)
        }
        
    }
    
    func makeSettingsView(coordinator: MyPageCoordinator) -> SettingsView {
        let usecase = MockSettingsUseCase()
        let vm = SettingsViewModel(useCase: usecase)
        return SettingsView(viewModel: vm, coordinator: coordinator)
    }
    struct MockSettingsUseCase: SettingsUseCaseProtocol {
        func setNotificationSettings(setting entity: NotificationEntity) async throws {}
        
        func getNotificationSettings() async throws -> NotificationEntity {
            return NotificationEntity (dailyEnabled: true, weeklyEnabled: true, marketingConsent: true)
        }
        
        func logout() async throws {
            throw NetworkError.dataNil
        }
    }
    
    func makeAlarmSettingsView() -> AlarmSettingsView {
        let usecase = MockSettingsUseCase()
        let vm = SettingsViewModel(useCase: usecase)
        return AlarmSettingsView(viewModel: vm)
    }
    
    func makeChallengeReportView(challengeId: Int, coordinator: MyPageCoordinator) -> ChallengeReportView {
        let usecase = MockChallengeReportUseCase()
        let viewModel = ChallengeReportViewModel(challengeId: challengeId, useCase: usecase)
        return ChallengeReportView(viewModel: viewModel, coordinator: coordinator)
    }
}
