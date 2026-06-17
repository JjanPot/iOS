//
//  ChallengeReportViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//


import SwiftUI
import Combine


final class ChallengeReportViewModel: ObservableObject {
    private let challengeId: Int
    private let useCase: ChallengeReportUseCaseProtocol
    init(challengeId: Int, useCase: ChallengeReportUseCaseProtocol) {
        self.challengeId = challengeId
        self.useCase = useCase
    }
    
    // MARK: - output property..
    
    // 결과지
    @Published var reportViewData: ChallengeReportViewData?
    // 절약현황
    @Published var summaryViewData: ChallengeSummaryViewData?
    // 챌린지 기본 정보
    @Published var detailViewData: ChallengeBasicInfoViewData?
    @Published var isLoading = false
    @Published var toastMessage: String?
    
    // MARK: - input methods..
    
    @MainActor
    func loadReport() {
        isLoading = true
        Task {
            do {
                let detail = try await useCase.getDetail(challengeId: challengeId)
                
                // 챌린지 상세 정보 가져오기
                let detailVD = ChallengeDetailViewDataMapper().map(from: detail)
                detailViewData = detailVD.basicInfo
                
                // 결과 리포트 가져오기
                let report = try await useCase.report(challengeId: challengeId)
                reportViewData = ChallengeReportViewDataMapper().map(from: report, detailEntity: detail)
                
            } catch {
                if let networkError = error as? NetworkError {
                    Logger.error("챌린지 리포트 불러오기 실패: \(networkError.description)")
                    ToastManager.shared.show(networkError.description)
                } else {
                    Logger.error("챌린지 리포트 불러오기 실패: \(error.localizedDescription)")
                    toastMessage = "불러오기 실패 \(error.localizedDescription)"
                }
            }
            isLoading = false
        }
    }
    
    @MainActor
    func loadSummary(){
        isLoading = true
        Task {
            do {
                let entity = try await useCase.fetchChallengeSummary(challengeId: challengeId)
                summaryViewData = ChallengeSummaryViewDataMapper().map(from: entity)
            } catch {
                if let networkError = error as? NetworkError {
                    Logger.error("챌린지 절약현황 불러오기 실패: \(networkError.description)")
                    ToastManager.shared.show(networkError.description)
                } else {
                    Logger.error("챌린지 절약현황 불러오기 실패: \(error.localizedDescription)")
                    toastMessage = "불러오기 실패 \(error.localizedDescription)"
                }
            }
            isLoading = false
        }
    }
}
