//
//  SettingsUseCaseProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//


protocol SettingsUseCaseProtocol {
    func logout() async throws
    func withdraw() async throws
    func setNotificationSettings(setting entity: NotificationEntity) async throws
    func getNotificationSettings() async throws -> NotificationEntity
}
struct SettingsUseCase: SettingsUseCaseProtocol {
    private let repository: SettingsRepositoryProtocol
    init(repository: SettingsRepositoryProtocol) {
        self.repository = repository
    }
    
    func logout() async throws {
        AuthManager.shared.logout()
        
        // api: 로그아웃
        guard let userId = getUserId() else {
            Logger.error("user id 못가져옴")
            throw NetworkError.requestFailed("userId is nil")
        }
        try await repository.logout(userId: userId)
    }
    
    private func getUserId() -> Int? {
        AuthManager.shared.currentUser?.userId
    }
    
    func withdraw() async throws {
        try await repository.withdraw()
        AuthManager.shared.logout()
    }
    
    
    func setNotificationSettings(setting entity: NotificationEntity) async throws {
        try await repository.setNotificationSettings(setting: entity)
        
    }
    
    func getNotificationSettings() async throws -> NotificationEntity {
        try await repository.getNotificationSettings()
    }
}
