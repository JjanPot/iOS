//
//  MyPotRepository.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//


struct MyPotRepository: MyPotRepositoryProtocol {
    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }

    
    func logout(userId: Int) async throws {
        let result = await authApiClient.logout(userId: userId)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}
