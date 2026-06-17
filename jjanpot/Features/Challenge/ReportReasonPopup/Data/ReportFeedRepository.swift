//
//  ReportFeedRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/11/26.
//

import Foundation


struct ReportFeedRepository: ReportFeedRepositoryProtocol {
    private let apiClient: ChallengeApiClientProtocol

    init(apiClient: ChallengeApiClientProtocol) {
        self.apiClient = apiClient
    }

    func reportFeed(feedId: Int, reason: String) async throws {
        let result = await apiClient.reportFeed(feedId: feedId, reason: reason)
        switch result {
        case .success(let dto):
            return
            
        case .failure(let error):
            throw error
        }

    }

    func reportUser(userId: Int, challengeId: Int, reason: String) async throws {
        let result = await apiClient.reportUser(userId: userId, challengeId: challengeId, reason: reason)
        switch result {
        case .success(let dto):
            return
            
        case .failure(let error):
            throw error
        }
    }
}
