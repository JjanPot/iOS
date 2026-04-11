//
//  ReportReasonSelectorPopupViewModel.swift
//  jjanpot
//
//  Created by 임주희 on 4/11/26.
//

import Foundation
import Combine



final class ReportReasonSelectorPopupViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var toastMessage: String?
    @Published var isSuccessed: Bool = false

    private let useCase: ReportFeedUseCaseProtocol
    private let reportType: ReportType


    init(useCase: ReportFeedUseCaseProtocol, reportType: ReportType) {
        self.useCase = useCase
        self.reportType = reportType
    }

    // 신고하기
    func report(reason: String) {
        isLoading = true
        Task {
            do {
                switch reportType {
                case let .feed(feedId):
                    try await useCase.reportFeed(feedId: feedId, reason: reason)
                case let .user(userId, challengeId):
                    try await useCase.reportUser(userId: userId, challengeId: challengeId, reason: reason)
                }
                isSuccessed = true
                ToastManager.shared.show("신고되었습니다.")
            } catch {
                Logger.error("신고 실패: \(error.localizedDescription)")
                if let networkError = error as? NetworkError {
                    toastMessage = networkError.description
                } else {
                    toastMessage = "신고 실패"
                }
            }
            isLoading = false
        }
    }
}
