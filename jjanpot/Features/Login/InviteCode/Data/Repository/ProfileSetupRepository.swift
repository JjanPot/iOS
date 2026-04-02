//
//  ProfileSetupRepository.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//


struct ProfileSetupRepository: ProfileSetupRepositoryProtocol {
    private let authApiClient: AuthApiClientProtocol

    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }

    
    func setProfile(nickname: String, birthDate: String?, imageUrl: String?) async throws {
        let result = await authApiClient.setProfile(nickname: nickname, birthDate: birthDate, imageUrl: imageUrl)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
}


