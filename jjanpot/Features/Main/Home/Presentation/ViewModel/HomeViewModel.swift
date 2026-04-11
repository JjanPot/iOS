//
//  HomeViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import Foundation
import SwiftUI
import Combine
import UserNotifications

final class HomeViewModel: ObservableObject {

    private let useCase: HomeUseCaseProtocol

    init(useCase: HomeUseCaseProtocol) {
        self.useCase = useCase
        
        self.homeViewData = HomeViewDataMapper().map(from: HomeEntity(challenge: .init(status: .none), summary: nil))
    }

    // MARK: - Output Properties

    @Published var homeViewData: HomeViewData
    
    @Published var showReportPopup = false
    @Published var completeChallengeId: Int?
    
    @Published var isLoading = false
    @Published var toastMessage: String?

    // MARK: - Input Methods

    func loadHomeData() {
        guard AuthManager.shared.isLoggedIn else { return }
        
        guard !isLoading else { return }

        Task {
            await fetchHomeData()
        }
    }
    
    func requestAuthorization(){
        let center = UNUserNotificationCenter.current()
        // 권한 상태 확인 후, 아직 결정되지 않은 경우에만 요청
        center.getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                    
                    if let error = error {
                        // Handle the error here.
                        Logger.error("알림 권한 \(error.localizedDescription)")
                    }
                    // Enable or disable features based on the authorization.
                }
            }
        }
    }

    
    @MainActor
    func loadHistories() {
        guard AuthManager.shared.isLoggedIn else { return }
        isLoading = true
        Task {
            do {
                let entities = try await useCase.loadHistories()
                guard let lastChallenge = entities.first else { return }
                
                // 종료된지 7일 이내의 경우만 띄운다.
                let daysDiff = Calendar.current.dateComponents([.day], from: lastChallenge.endDate, to: Date()).day ?? 0
                let isWithin7Days = daysDiff >= 0 && daysDiff <= 7
                guard isWithin7Days else { return }
                
                // 다시보지않기로 한 아이디가 없거나, 새로운 아이디랑 다를 경우
                let loadLatestCompletedChallengeId = useCase.loadLatestCompletedChallengeId() ?? -1
                if lastChallenge.challengeId != loadLatestCompletedChallengeId {
                    showReportPopup = true
                    completeChallengeId = lastChallenge.challengeId
                }
                
            } catch {
                Logger.error("챌린지 기록 불러오기 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    Logger.error("챌린지 기록 불러오기 실패: \(networkError.description)")
                    toastMessage = networkError.description
                } else {
                    toastMessage = "불러오기 실패"
                }
            }
            isLoading = false
        }
    }
    
    // MARK: - Private Methods

    @MainActor
    private func fetchHomeData() async {
        isLoading = true
        do {
            let entity = try await useCase.fetchChallengeData()
            let viewData = HomeViewDataMapper().map(from: entity)
            self.homeViewData = viewData
            isLoading = false

        } catch {
            Logger.error("홈 데이터 로드 실패: \(error)")
            toastMessage = "데이터를 불러오는데 실패했습니다."
            isLoading = false
        }
    }
}
