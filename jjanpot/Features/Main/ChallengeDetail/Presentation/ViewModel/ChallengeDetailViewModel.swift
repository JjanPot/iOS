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
    @Published var memberViewDatas: [MemberCardViewData] = []
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
                
                let memberEntitis = try await useCase.getMembers(challengeId: challengeId)
                memberViewDatas = MemberCardViewDataMapper().map(from: memberEntitis)
                
            } catch {
                Logger.error("상세정보 불러오기 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    Logger.error("상세정보 불러오기 실패: \(networkError.description)")
                    if networkError.isUserFacing {
                        toastMessage = networkError.description
                    }
                } else {
                    toastMessage = "상세정보 불러오기 실패 \(error.localizedDescription)"
                }
            }
            
            isLoading = false
        }
    }
    
    
    /// 챌린지 취소하기 (대기중에만 취소가능)
    @MainActor
    func cancel(){
        isCancelled = false
        isLoading = true
        Task {
            do {
                try await useCase.cancel(challengeId: challengeId)
                ToastManager.shared.show("챌린지가 취소되었습니다.")
                isShowCancelAlert = false
                isCancelled = true
                // 홈화면 리로드
                //NotificationCenter.default.post(name: .shouldRefreshMain, object: nil)
            } catch {
                Logger.error("챌린지 취소하기 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    Logger.error("챌린지 취소하기 실패: \(networkError.description)")
                    if networkError.isUserFacing {
                        toastMessage = networkError.description
                    }
                } else {
                    toastMessage = "취소하기 실패 \(error.localizedDescription)"
                }
            }
        }
        isLoading = false
    }
    
    
    /// 리뷰용 - 챌린지 즉시 시작
    func startChallenge() {
        isLoading = true
        Task {
            do {
                try await useCase.startChallenge(id: challengeId)
                toastMessage = "챌린지가 시작되었습니다."
                
                // 새로고침
                getDetail()
            } catch {
                Logger.error("챌린지 시작 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    Logger.error("챌린지 시작 실패: \(networkError.description)")
                    if networkError.isUserFacing {
                        toastMessage = networkError.description
                    }
                } else {
                    toastMessage = "챌린지 시작 실패 \(error.localizedDescription)"
                }
            }
            isLoading = false
        }
    }
    
    /// 리뷰용 - 챌린지 즉시 종료
    func finishChallenge() {
        isLoading = true
        Task {
            do {
                try await useCase.finishChallenge(id: challengeId)
                ToastManager.shared.show("챌린지가 종료되었습니다.")
                isCancelled = true
                
                // 홈화면 리로드
                //NotificationCenter.default.post(name: .shouldRefreshMain, object: nil)
            } catch {
                Logger.error("챌린지 종료 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    Logger.error("챌린지 종료 실패: \(networkError.description)")
                    if networkError.isUserFacing {
                        toastMessage = networkError.description
                    }
                } else {
                    toastMessage = "챌린지 종료 실패 \(error.localizedDescription)"
                }
            }
            isLoading = false
        }
    }
}
