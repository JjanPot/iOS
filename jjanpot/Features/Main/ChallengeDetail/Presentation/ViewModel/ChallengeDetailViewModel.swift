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
    
    @Published var isShowCancelAlert: Bool = false
    @Published var isCancelled: Bool = false
    
    
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
    
    @MainActor
    func cancel(){
        isCancelled = false
        isLoading = true
        Task {
            do {
                try await useCase.cancel(challengeId: challengeId)
                ToastManager.shared.show("챌린지 취소 완료")
                isShowCancelAlert = false
                isCancelled = true
            } catch {
                if let networkError = error as? NetworkError {
                    Logger.error("챌린지 인증 실패: \(networkError.description)")
                    ToastManager.shared.show(networkError.description)
                } else {
                    Logger.error("챌린지 인증 실패: \(error.localizedDescription)")
                    toastMessage = "취소하기 실패 \(error.localizedDescription)"
                }
            }
        }
        isLoading = false
    }
}
