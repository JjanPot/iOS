//
//  ChallengePostRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/1/26.
//


import UIKit

protocol ChallengePostRepositoryProtocol {
    func fetchDetail(challengeId: Int) async throws -> ChallengeDetailEntity
    func postChallenge(entity: ChallengePostRequestEntity, imageData: Data?) async throws
}
