//
//  MyPotRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//


protocol MyPotRepositoryProtocol {
    func getMyChallengeStats() async throws -> ChallengeStatsEntity
}

