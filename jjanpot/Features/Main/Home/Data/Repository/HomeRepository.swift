//
//  HomeRepository.swift
//  jjanpot
//
//  Created by 임주희 on 3/26/26.
//


import Foundation

struct HomeRepository: HomeRepositoryProtocol {

    // TODO: API Client 추가 시 주입
    // private let apiClient: HomeApiClientProtocol

    func fetchHomeData() async throws -> HomeEntity {
        // TODO: 실제 API 호출로 교체
        // let result = await apiClient.fetchHomeData()
        // return mapToEntity(result)

        throw NetworkError.cancelled
    }
}
