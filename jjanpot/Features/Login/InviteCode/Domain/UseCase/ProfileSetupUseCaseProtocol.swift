//
//  ProfileSetupUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//

import Foundation

protocol ProfileSetupUseCaseProtocol {
    func setProfile(nickname: String, birthDate: String?, imageUrl: String?) async throws
}
struct ProfileSetupUseCase: ProfileSetupUseCaseProtocol {
    private let repository: ProfileSetupRepositoryProtocol
    init(repository: ProfileSetupRepositoryProtocol) {
        self.repository = repository
    }
    
    func setProfile(nickname: String, birthDate: String?, imageUrl: String?) async throws {
        try await repository.setProfile(nickname: nickname, birthDate: birthDate, imageUrl: imageUrl)
    }
}


