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
    func makeChallengeDetailView(challengeId: Int, coordinator: MainCoordinator) -> ChallengeDetailView

    /// 챌린지 대시보드화면
    func makeChallengeDashboardView(coordinator: MainCoordinator) -> ChallengeDashboardView

    /// 지출,무지출 인증
    func makeChallengePostView(challengeId: Int, coordinator: MainCoordinator) -> ChallengePostView

    // MyPage - 마이팟
    func makeMyPotView(coordinator: MainCoordinator) -> MyPotView

    // 설정화면
    func makeSettingsView(coordinator: MainCoordinator) -> SettingsView

    // 알람 설정
    func makeAlarmSettingsView() -> AlarmSettingsView

    // 챌린지 결과
    func makeChallengeReportView(challengeId: Int, coordinator: MainCoordinator) -> ChallengeReportView
    
    // 완료 챌린지 목록
    func makeChallengeHistoryView(coordinator: MainCoordinator) -> ChallengeHistoryView
    
    // 완료챌린지 결과화면 안내 팝업
    func makeReportPopupView(challengeId: Int, comfirmAction: @escaping ()-> Void, closeAction : @escaping ()-> Void ) -> ReportPopupView
    
    // 신고 이유 선택지 화면
    func makeReportReasonSelectorPopupView<Reason: ReportReasonProtocol & Hashable & CaseIterable>(
        reason: Reason,
        reportType: ReportType,
        confirmAction: @escaping () -> Void,
        closeAction: @escaping () -> Void
    ) -> ReportReasonSelectorPopup<Reason>
    
    func makeWebView(url: String, onDismiss: @escaping ()-> Void) -> WebView
}

final class MainDIContainer: MainDIContainerProtocol {
    private let authApiClient: AuthApiClientProtocol
    private let challengeApiClient: ChallengeApiClientProtocol

    init(authApiClient: AuthApiClientProtocol, challengeApiClient: ChallengeApiClientProtocol) {
        self.authApiClient = authApiClient
        self.challengeApiClient = challengeApiClient
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
    private func makeInviteCodeViewModel() -> InviteCodeViewModel {
        let usecase = makeInviteCodePopupUseCase()
        return InviteCodeViewModel(useCase: usecase)
    }
    
    func makeInviteCodePopupView(inviteCode: String?, onCloseAction: @escaping ()-> Void ) -> InviteCodePopupView {
        let vm = makeInviteCodeViewModel()
        return InviteCodePopupView(viewModel: vm, inviteCode: inviteCode, onCloseAction: { onCloseAction() })
    }
    func makeReportPopupView(challengeId: Int, comfirmAction: @escaping ()-> Void, closeAction : @escaping ()-> Void ) -> ReportPopupView {
        return ReportPopupView(challengeId: challengeId, comfirmAction: comfirmAction, closeAction: closeAction)
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
    func makeChallengeDetailView(challengeId: Int, coordinator: MainCoordinator) -> ChallengeDetailView {
        let vm = makeChallengeDetailViewModel(challengeId: challengeId)
        return ChallengeDetailView(viewModel: vm, coordinator: coordinator)
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
    
    // MARK: - 완료된 챌린지 목록
    
    private func makeChallengeHistoryRepository() -> ChallengeHistoryRepositoryProtocol {
        return ChallengeHistoryRepository(challengeApiClient: challengeApiClient)
    }
    private func makeChallengeHistoryUseCase() -> ChallengeHistoryUseCaseProtocol {
        let repo = makeChallengeHistoryRepository()
        return ChallengeHistoryUseCase(repository: repo)
    }
    private func makeChallengeHistoryViewModel() -> ChallengeHistoryViewModel {
        let usecase = makeChallengeHistoryUseCase()
        return ChallengeHistoryViewModel(useCase: usecase)
    }
    
    func makeChallengeHistoryView(coordinator: MainCoordinator) -> ChallengeHistoryView {
        let vm = makeChallengeHistoryViewModel()
        return ChallengeHistoryView(viewModel: vm, coordinator: coordinator)
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
    
    func makeChallengeReportView(challengeId: Int, coordinator: MainCoordinator) -> ChallengeReportView {
        let vm = makeChallengeReportViewModel(challengeId: challengeId)
        return ChallengeReportView(viewModel: vm, coordinator: coordinator)
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

    func makeMyPotView(coordinator: MainCoordinator) -> MyPotView {
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
    
    func makeSettingsView(coordinator: MainCoordinator) -> SettingsView {
        let vm = makeSettingsViewModel()
        return SettingsView(viewModel: vm, coordinator: coordinator)
    }
    
    // MARK: - 설정화면 > 알람 설정화면
    func makeAlarmSettingsView() -> AlarmSettingsView {
        let vm = makeSettingsViewModel()
        return AlarmSettingsView(viewModel: vm)
    }
    
    // MARK: - 신고 이유 선택지 팝업

    private func makeReportFeedRepository() -> ReportFeedRepositoryProtocol {
        return ReportFeedRepository(apiClient: challengeApiClient)
    }

    private func makeReportFeedUseCase() -> ReportFeedUseCaseProtocol {
        let repo = makeReportFeedRepository()
        return ReportFeedUseCase(repository: repo)
    }

    private func makeReportReasonSelectorPopupViewModel(reportType: ReportType) -> ReportReasonSelectorPopupViewModel {
        let useCase = makeReportFeedUseCase()
        return ReportReasonSelectorPopupViewModel(useCase: useCase, reportType: reportType)
    }

    func makeReportReasonSelectorPopupView<Reason: ReportReasonProtocol & Hashable & CaseIterable>(
        reason: Reason,
        reportType: ReportType,
        confirmAction: @escaping () -> Void,
        closeAction: @escaping () -> Void
    ) -> ReportReasonSelectorPopup<Reason> {
        let viewModel = makeReportReasonSelectorPopupViewModel(reportType: reportType)
        return ReportReasonSelectorPopup(viewModel: viewModel, reason: reason, onConfirm: confirmAction, onClose: closeAction)
    }
    
    func makeWebView(url: String, onDismiss: @escaping ()-> Void) -> WebView {
        WebView(url: url, onDismiss: onDismiss)
    }
}

// MARK: - Mock

final class MockMainDIContainer: MainDIContainerProtocol {
    
    func makeInviteCodePopupView(inviteCode: String?, onCloseAction: @escaping ()-> Void ) -> InviteCodePopupView {
        let vm = InviteCodeViewModel(useCase: MockInviteCodePopupUseCase())
        return InviteCodePopupView(viewModel: vm, inviteCode: inviteCode, onCloseAction: { onCloseAction() })
    }
    func makeReportPopupView(challengeId: Int, comfirmAction: @escaping ()-> Void, closeAction : @escaping ()-> Void ) -> ReportPopupView {
        return ReportPopupView(challengeId: challengeId, comfirmAction: comfirmAction, closeAction: closeAction)
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
    
    func makeChallengeDetailView(challengeId: Int, coordinator: MainCoordinator) -> ChallengeDetailView {
        let usecase = MockChallengeDetailUseCase()
        let vm = ChallengeDetailViewModel(challengeId: challengeId, useCase: usecase)
        return ChallengeDetailView(viewModel: vm, coordinator: coordinator)
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
    
    func makeChallengeReportView(challengeId: Int, coordinator: MainCoordinator) -> ChallengeReportView {
        let usecase = MockChallengeReportUseCase()
        let viewModel = ChallengeReportViewModel(challengeId: challengeId, useCase: usecase)
        return ChallengeReportView(viewModel: viewModel, coordinator: coordinator)
    }
    
    func makeSettingsView(coordinator: MainCoordinator) -> SettingsView {
        let usecase = MockSettingsUseCase()
        let vm = SettingsViewModel(useCase: usecase)
        return SettingsView(viewModel: vm, coordinator: coordinator)
    }
    
    
    func makeAlarmSettingsView() -> AlarmSettingsView {
        let usecase = MockSettingsUseCase()
        let vm = SettingsViewModel(useCase: usecase)
        return AlarmSettingsView(viewModel: vm)
    }
    
    func makeMyPotView(coordinator: MainCoordinator) -> MyPotView {
        let vm = MyPotViewModel(useCase: MockMyPotUseCase())
        return MyPotView(viewModel: vm, coordinator: coordinator)
    }
    
    func makeChallengeHistoryView(coordinator: MainCoordinator) -> ChallengeHistoryView {
        let usecase = MockChallengeHistoryUseCase()
        let viewModel = ChallengeHistoryViewModel(useCase: usecase)
        return ChallengeHistoryView(viewModel: viewModel, coordinator: coordinator)
    }
    func makeWebView(url: String, onDismiss: @escaping ()-> Void) -> WebView {
        WebView(url: url, onDismiss: onDismiss)
    }


    private func makeReportReasonSelectorPopupViewModel(reportType: ReportType) -> ReportReasonSelectorPopupViewModel {
        let useCase = MockReportFeedUseCase()
        return ReportReasonSelectorPopupViewModel(useCase: useCase, reportType: reportType)
    }

    func makeReportReasonSelectorPopupView<Reason: ReportReasonProtocol & Hashable & CaseIterable>(
        reason: Reason,
        reportType: ReportType,
        confirmAction: @escaping () -> Void,
        closeAction: @escaping () -> Void
    ) -> ReportReasonSelectorPopup<Reason> {
        let viewModel = makeReportReasonSelectorPopupViewModel(reportType: reportType)
        return ReportReasonSelectorPopup(viewModel: viewModel, reason: reason, onConfirm: confirmAction, onClose: closeAction)
    }

    struct MockChallengeHistoryUseCase: ChallengeHistoryUseCaseProtocol {
        func loadHistories() async throws -> [HistoryEntity] {
            [
                HistoryEntity(challengeId: 6, title: "카페는 이제 그만!", status: "COMPLETED", statusDisplayName: "목표 달성 성공 챌린지", goalAmount: 300000, startDate: Date(), endDate: Date())
            ]
        }
    }
    
// MARK: - Mock UseCase
    final class MockChallengeDetailUseCase: ChallengeDetailUseCaseProtocol {
        func cancel(challengeId: Int) async throws {
            throw NetworkError.dataNil
        }
        
        func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity {
            throw NetworkError.dataNil
        }
    }
    
    final class MockHomeUseCase: HomeUseCaseProtocol {
        func loadHistories() async throws -> [HistoryEntity] {
            throw NetworkError.dataNil
        }
        
        func loadLatestCompletedChallengeId() -> Int? {
            -1
        }
        
        func fetchChallengeData() async throws -> HomeEntity {
            HomeEntity(
                challenge: CurrentChallengeEntity(status: .inProgress(entity: ChallengeInProgressEntity(
                    challengeId: 1, title: "카페는 이제 그만", endDate: Date(), weekNumber: 1, weekGoalAmount: 300000, teamWeekSavedAmount: 200000, personalWeekSavedAmount: 10000, achievementRate: 10
                ))),
                summary: ChallengeSummaryEntity(team: ChallengeSummaryEntity.Team(avgCertificationCount: 10, participationRate: 10, consecutiveDays: 10), personal: ChallengeSummaryEntity.Personal(
                    certificationCount: 5, participationRate: 10, consecutiveDays: 2
                ))
            )
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
    struct MockChallengeDashboardUseCase: ChallengeDashboardUseCaseProtocol {
        func reportFeed(feedId: Int, reason: String) async throws {
            return
        }
        
        func reportUser(userId: Int, challengeId: Int, reason: String) async throws {
            return
        }
        
        func blockUser(userId: Int, challengeId: Int) async throws {
            return
        }
        
        func getChallengeDashboardData() async throws -> ChallengeDashboardEntity {
            return ChallengeDashboardEntity.inProgress(
                id: 0, overview: OverviewEntity(
                    challengeId: 1,
                    title: "카페는 이제 그만!",
                    startDate: Date(),
                    totalSavedAmount: 206100,
                    goalAmount: 300000,
                    members: [
                        .init(userId: 1, nickname: "닉네임", profileImageURL: nil, savedAmount: 10000, isMe: false),
                        .init(userId: 1, nickname: "닉네임", profileImageURL: nil, savedAmount: 10000, isMe: true)
                    ]
                ),
                feeds: []
            )
        }
    }
    struct MockChallengePostUseCase: ChallengePostUseCaseProtocol {
        func postChallenge(entity: ChallengePostRequestEntity, imageData: Data?) async throws {
            throw NetworkError.dataNil
        }
        
        func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity {
            throw NetworkError.dataNil
        }
    }
    
    struct MockReportFeedUseCase: ReportFeedUseCaseProtocol{
        func reportFeed(feedId: Int, reason: String) async throws {}
        
        func reportUser(userId: Int, challengeId: Int, reason: String) async throws {}
        
    }
}

struct MockInviteCodePopupUseCase: InviteCodePopupUseCaseProtocol {
    func submitInviteCode(code: String) async throws {
        throw NetworkError.dataNil
    }
}


struct MockChallengeReportUseCase: ChallengeReportUseCaseProtocol {
    func getDetail(challengeId: Int) async throws -> ChallengeDetailEntity {
        ChallengeDetailEntity(
            challengeId: 6,
            title: "배달아껴팀",
            description: "함께 절약해보야요",
            status: "진행중",
            goalAmount: 300_000,
            minPersonalGoalAmount: 25_000,
            startDate: Date(),
            endDate: Date(),
            categories: [.init(categoryId: 1, name: "외식/배달", iconURL: nil, amount: 10000)],
            team: .init(teamId: 1,
                        inviteCode: "code",
                        currentMemberCount: 6, maxMemberCount: 6, teamType: ""),
            isLeader: true)
    }
    
    func fetchChallengeSummary(challengeId: Int) async throws -> ChallengeSummaryEntity {
        ChallengeSummaryEntity(team: ChallengeSummaryEntity.Team(
            avgCertificationCount: 5.0, participationRate: 133, consecutiveDays: 10
        ), personal: ChallengeSummaryEntity.Personal(
            certificationCount: 1, participationRate: 40, consecutiveDays: 2))
    }
    
    func report(challengeId: Int) async throws -> ChallengeReportEntity {
        return ChallengeReportEntity(
            isTeamSuccess: true,
            goalAmount: 300_000,
            totalSavedAmount: 312_500,
            achievementRate: 104,
            categoryNames: ["외식/배달"],
            personalSavedAmount: 25000
        )
        
        // 실패의 경우
//            ChallengeReportEntity(
//                isTeamSuccess: false,
//                goalAmount: 300_000,
//                totalSavedAmount: 297_000,
//                achievementRate: 99,
//                categoryNames: ["외식/배달"],
//                personalSavedAmount: 25000
//            )
    }
}
struct MockSettingsUseCase: SettingsUseCaseProtocol {
    func setNotificationSettings(setting entity: NotificationEntity) async throws {}
    
    func getNotificationSettings() async throws -> NotificationEntity {
        return NotificationEntity (dailyEnabled: true, weeklyEnabled: true, marketingConsent: true)
    }
    func logout() async throws {
        throw NetworkError.dataNil
    }
    func withdraw() async throws {
        throw NetworkError.dataNil
    }
}
struct MockMyPotUseCase: MyPotUseCaseProtocol {
    func getUserInfo() async throws -> UserEntity {
        UserEntity(userId: 3, nickname: "주희희", imageUrl: "https://picsum.photos/100/100")
    }
    
    func getMyChallengeStats() async throws -> ChallengeStatsEntity {
        ChallengeStatsEntity(totalCount: 10, successCount: 3, failCount: 7, successRate: 10)
    }
    
}
