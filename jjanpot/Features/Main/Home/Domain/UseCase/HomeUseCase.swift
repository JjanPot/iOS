//
//  HomeUseCase.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import Foundation

final class HomeUseCase: HomeUseCaseProtocol {
    private let repository: HomeRepositoryProtocol

    init(repository: HomeRepositoryProtocol) {
        self.repository = repository
    }

    func fetchHomeData() async throws -> HomeEntity {
        return try await repository.fetchHomeData()
    }
}
