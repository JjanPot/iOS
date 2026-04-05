//
//  ChallengeHistoryViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 4/5/26.
//


import SwiftUI
import Combine
final class ChallengeHistoryViewModel: ObservableObject {
    private let useCase: ChallengeHistoryUseCaseProtocol
    init(useCase: ChallengeHistoryUseCaseProtocol) {
        self.useCase = useCase
    }
    
    @Published var viewDatas: [ChallengeHistoryCardViewData] = []
    @Published var isLoading = false
    @Published var toastMessage: String?
    
    @MainActor
    func loadHistories() {
        isLoading = true
        Task {
            do {
                let entities = try await useCase.loadHistories()
                viewDatas = entities.map{ChallengeHistoryCardViewDataMapper().map(from: $0)}
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
}

