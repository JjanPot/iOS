//
//  ReportFeedUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/11/26.
//

protocol ReportFeedUseCaseProtocol {
    /// 게시글 신고
    func reportFeed(feedId: Int, reason: String) async throws

    /// 사용자 신고
    func reportUser(userId: Int, challengeId: Int, reason: String) async throws
}

struct ReportFeedUseCase: ReportFeedUseCaseProtocol {
    private let repository: ReportFeedRepositoryProtocol

    init(repository: ReportFeedRepositoryProtocol) {
        self.repository = repository
    }

    func reportFeed(feedId: Int, reason: String) async throws {
        try await repository.reportFeed(feedId: feedId, reason: reason)
    }

    func reportUser(userId: Int, challengeId: Int, reason: String) async throws {
        try await repository.reportUser(userId: userId, challengeId: challengeId, reason: reason)
    }
}
