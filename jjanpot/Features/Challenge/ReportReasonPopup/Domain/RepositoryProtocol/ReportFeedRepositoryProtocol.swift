//
//  ReportFeedRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/11/26.
//


protocol ReportFeedRepositoryProtocol {
    /// 게시글 신고
    func reportFeed(feedId: Int, reason: String) async throws

    /// 사용자 신고
    func reportUser(userId: Int, challengeId: Int, reason: String) async throws
}
