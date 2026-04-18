//
//  FeedPostRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//


import UIKit

protocol FeedPostRepositoryProtocol {
    func fetchDetail(challengeId: Int) async throws -> ChallengeDetailEntity
    func postChallenge(entity: FeedPostRequestEntity, imageData: Data?) async throws
}
