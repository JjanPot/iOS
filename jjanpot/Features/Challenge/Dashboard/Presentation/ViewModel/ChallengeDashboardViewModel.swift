//
//  ChallengeDashboardViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


import SwiftUI
import Combine
final class ChallengeDashboardViewModel: ObservableObject {
    
    
    @Published var viewData: ChallengeDashboardViewData? = nil
    @Published var isLoading = false
    @Published var toastMessage: String?
    
    private let useCase: ChallengeDashboardUseCaseProtocol
    init(useCase: ChallengeDashboardUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func loadChallengeDashboard() {
        isLoading = true
        Task {
            do {
                let entity = try await useCase.getChallengeDashboardData()
                
                switch entity {
                case .none:
                    self.viewData = ChallengeDashboardViewData.noneChallenge
                case .waiting:
                    self.viewData = ChallengeDashboardViewData.waiting
                case let .inProgress(id, overview, feeds):
                    let overview = ChallengeOverviewViewDataMapper().map(from: overview)
                    let feed: [ChallengeFeedViewData] = []
                    self.viewData = ChallengeDashboardViewData.inProgress(
                        challengeId: id,
                        overviewViewData: overview,
                        feedViewData: feed
                    )
                }
                 
            } catch {
                Logger.error("loadChallengeOverview 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    ToastManager.shared.show(networkError.description)
                } else {
                    toastMessage = "불러오기 실패"
                }
            }
            isLoading = false
        }
    }
}
  



