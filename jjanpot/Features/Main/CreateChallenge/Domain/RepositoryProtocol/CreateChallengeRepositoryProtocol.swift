//
//  CreateChallengeRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/30/26.
//


import Foundation

protocol CreateChallengeRepositoryProtocol {
    func fetchCategories() async throws -> [CategoryEntity]
    func createChallenge(entity: CreateChallengeRequestEntity) async throws -> CreateChallengeEntity
}
