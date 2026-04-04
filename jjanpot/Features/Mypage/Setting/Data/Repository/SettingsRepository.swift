//
//  SettingsRepository.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//

import Foundation

struct SettingsRepository: SettingsRepositoryProtocol {
    private let authApiClient: AuthApiClientProtocol
    
    init(authApiClient: AuthApiClientProtocol) {
        self.authApiClient = authApiClient
    }
    
    // 로그아웃
    func logout(userId: Int) async throws {
        let result = await authApiClient.logout(userId: userId)
        switch result {
        case .success:
            return
        case .failure(let error):
            throw error
        }
    }
    
    // 알림 설정
    func setNotificationSettings(setting entity: NotificationEntity) async throws {
        let dto = NotificationDto(from: entity)
        let result = await authApiClient.setNotificationSettings(setting: dto)
        switch result {
        case .success(let dto):
            return
            
        case .failure(let error):
            throw error
        }
    }
    
    // 알림 설정 가져오기
    func getNotificationSettings() async throws -> NotificationEntity {
        let result = await authApiClient.getNotificationSettings()
        switch result {
        case .success(let dto):
            return NotificationEntity(from: dto)
            
        case .failure(let error):
            throw error
        }
    }
}
