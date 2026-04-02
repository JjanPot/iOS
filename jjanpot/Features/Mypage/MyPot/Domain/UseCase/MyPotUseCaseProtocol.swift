//
//  MyPotUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/3/26.
//


protocol MyPotUseCaseProtocol {
    func logout() async throws
}
struct MyPotUseCase: MyPotUseCaseProtocol {
    private let repository: MyPotRepositoryProtocol
    init(repository: MyPotRepositoryProtocol) {
        self.repository = repository
    }
    
    
    func logout() async throws {
        guard let userId = getUserId() else {
            Logger.error("user id 못가져옴")
            throw NetworkError.requestFailed("userId is nil")
        }
        try await repository.logout(userId: userId)
        AuthManager.shared.logout()
    }
    
    private func getUserId() -> Int? {
        AuthManager.shared.currentUser?.userId
    }
}


