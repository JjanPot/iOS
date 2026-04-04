//
//  SettingsRepositoryProtocol.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//


protocol SettingsRepositoryProtocol {
    func logout(userId: Int) async throws
    func setNotificationSettings(setting entity: NotificationEntity) async throws
    func getNotificationSettings() async throws -> NotificationEntity 
}
