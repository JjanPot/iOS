//
//  NotificationEntity.swift
//  jjanpot
//
//  Created by 임주희 on 4/4/26.
//

import Foundation

struct NotificationEntity {
    let dailyEnabled, weeklyEnabled, marketingConsent: Bool
}
extension NotificationEntity {
    init(from dto: NotificationDto){
        self.dailyEnabled = dto.dailyEnabled
        self.weeklyEnabled = dto.weeklyEnabled
        self.marketingConsent = dto.marketingConsent
    }
}
extension NotificationDto {
    init(from entity: NotificationEntity){
        self.dailyEnabled = entity.dailyEnabled
        self.weeklyEnabled = entity.weeklyEnabled
        self.marketingConsent = entity.marketingConsent
    }
}
