//
//  ChallengeDashboardViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//


import SwiftUI
import Combine
final class ChallengeDashboardViewModel: ObservableObject {
    
    @Published var members: [MemberCardViewData] = [
        .init(imageUrl: "https://picsum.photos/50/50",
              color: .red,
              name: "닉네임",
              amount: 10000),
        .init(imageUrl: "https://picsum.photos/50/50",
              color: .blue,
              name: "닉네임",
              amount: 10000),
        .init(imageUrl: "https://picsum.photos/50/50",
              color: .yellow,
              name: "닉네임",
              amount: 10000),
        .init(imageUrl: "https://picsum.photos/50/50",
              color: .green,
              name: "닉네임",
              amount: 10000),
    ]
    
    
    @Published var isLoading = false
    @Published var toastMessage: String?
    
    private let useCase: ChallengeDashboardUseCaseProtocol
    init(useCase: ChallengeDashboardUseCaseProtocol) {
        self.useCase = useCase
    }
    
    // TODO: challengeId 가져오기
    func loadChallengeOverview() {
        isLoading = true
        Task {
            do {
                let entity = try await useCase.fetchChallengeOverview(challengeId: 0)
                // Entity → ViewData 변환
                
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
    
    
    func fetchFeed(challengeId: Int) {
        isLoading = true
        Task {
            do {
                let entity = try await useCase.fetchFeed(challengeId: 0)
                // Entity → ViewData 변환
            } catch {
                Logger.error("loadChallengeOverview 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    ToastManager.shared.show(networkError.description)
                } else {
                    toastMessage = "불러오기 실패"
                }
            }
            //isLoading = false
        }
        isLoading = false
    }
}



