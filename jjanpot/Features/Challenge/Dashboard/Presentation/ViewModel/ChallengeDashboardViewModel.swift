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
    
  
    
    /// 사용자 차단
    func blockUser(userId: Int, challengeId: Int) {
        isLoading = true
        Task {
            do {
                try await useCase.blockUser(userId: userId, challengeId: challengeId)
                removeFeed(userId: userId)
                toastMessage = "사용자가 차단되었습니다."
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
    
    
    /// 신고한 피드를 목록에서 제거
    func removeFeed(feedId targetId: Int){
        if case let .inProgress(challengeId, overviewViewData, feeds) = self.viewData {
            var filteredFeeds = feeds
            filteredFeeds.removeAll { feed in
                if case let .item(_, feedViewData) = feed {
                    return feedViewData.feedId == targetId
                }
                return false
            }
            
            self.viewData = .inProgress(challengeId: challengeId,
                                        overviewViewData: overviewViewData,
                                        feedViewData: filteredFeeds)
        }
    }
    
    /// 신고한 피드를 목록에서 제거
    func removeFeed(userId targetId: Int){
        if case let .inProgress(challengeId, overviewViewData, feeds) = self.viewData {
            var filteredFeeds = feeds
            filteredFeeds.removeAll { feed in
                if case let .item(_, feedViewData) = feed {
                    return feedViewData.authorId == targetId
                }
                return false
            }
            
            self.viewData = .inProgress(challengeId: challengeId,
                                        overviewViewData: overviewViewData,
                                        feedViewData: filteredFeeds)
        }
    }
    
}
  



