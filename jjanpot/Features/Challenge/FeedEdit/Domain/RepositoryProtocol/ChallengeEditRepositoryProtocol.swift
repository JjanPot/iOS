//
//  FeedEditRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/18/26.
//

import Foundation


protocol FeedEditRepositoryProtocol {
    func fetchDetail(challengeId: Int) async throws -> ChallengeDetailEntity
    func updateFeed(feedId: Int, entity: ChallengePostRequestEntity, imageData: Data?) async throws
}
