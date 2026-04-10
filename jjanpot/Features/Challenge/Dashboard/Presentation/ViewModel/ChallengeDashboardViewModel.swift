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
                    let feed: [ChallengeFeedViewData] = ChallengeFeedViewDataMapper().map(from: feeds)
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
    
    /// 게시글 신고
    func reportFeed(feedId: Int, reason: String) {
        isLoading = true
        Task {
            do {
                try await useCase.reportFeed(feedId: feedId, reason: reason)
            } catch {
                Logger.error("게시글 신고 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    Logger.error("게시글 신고 실패: \(networkError.description)")
                    toastMessage = networkError.description
                } else {
                    toastMessage = "게시글 신고 실패"
                }
            }
            isLoading = false
        }
    }
    
    /// 사용자 신고
    func reportUser(userId: Int, challengeId: Int, reason: String) {
        isLoading = true
        Task {
            do {
                try await useCase.reportUser(userId: userId, challengeId: challengeId, reason: reason)
            } catch {
                Logger.error("사용자 신고 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    Logger.error("사용자 신고 실패: \(networkError.description)")
                    toastMessage = networkError.description
                } else {
                    toastMessage = "사용자 신고 실패"
                }
            }
            isLoading = false
        }
    }
    
    /// 사용자 차단
    func blockUser(userId: Int, challengeId: Int) {
        isLoading = true
        Task {
            do {
                try await useCase.blockUser(userId: userId, challengeId: challengeId)
            } catch {
                Logger.error("사용자 차단 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    Logger.error("사용자 차단 실패: \(networkError.description)")
                    toastMessage = networkError.description
                } else {
                    toastMessage = "사용자 차단 실패"
                }
            }
            isLoading = false
        }
    }
}
  



