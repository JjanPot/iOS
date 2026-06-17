//
//  ChallengeHistoryUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/5/26.
//


protocol ChallengeHistoryUseCaseProtocol {
    func loadHistories() async throws -> [HistoryEntity]
}