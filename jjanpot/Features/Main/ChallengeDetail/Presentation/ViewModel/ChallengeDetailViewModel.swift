//
//  ChallengeDetailViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 3/31/26.
//

import Foundation
import Combine

final class ChallengeDetailViewModel: ObservableObject {
    
    private let challengeId: Int
    
    @Published var viewData: ChallengeDetailViewData?
    @Published var isLoading = false
    @Published var toastMessage: String?
    
    private let useCase: ChallengeDetailUseCaseProtocol

    init(challengeId: Int, useCase: ChallengeDetailUseCaseProtocol) {
        self.challengeId = challengeId
        self.useCase = useCase
    }
    
    // 상세정보 가져오기
    @MainActor
    func getDetail(){
        isLoading = true
        Task {
            do {
                let entity = try await useCase.getDetail(challengeId: challengeId)
                // Entity → ViewData 변환
                viewData = ChallengeDetailViewDataMapper().map(from: entity)
                
            } catch {
                Logger.error("상세정보 불러오기 실패: \(error.localizedDescription)")
                toastMessage = "상세정보 불러오기 실패"
            }
            isLoading = false
        }
    }
}
