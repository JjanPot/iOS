//
//  HomeUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import Foundation

protocol HomeUseCaseProtocol {
    func fetchHomeData() async throws -> HomeEntity
}
