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
    }

    // MARK: - Output Properties

    @Published var homeViewData: HomeViewData?
    @Published var isLoading = false
    
    @Published var toastMessage: String?

    // MARK: - Input Methods

    func loadHomeData() {
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
