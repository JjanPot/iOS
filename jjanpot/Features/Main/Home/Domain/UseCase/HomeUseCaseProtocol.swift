//
//  HomeUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import Foundation

protocol HomeUseCaseProtocol {
    func fetchChallengeData() async throws -> HomeEntity
}
