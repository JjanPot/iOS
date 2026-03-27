//
//  HomeViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import Foundation
import SwiftUI
import Combine

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
