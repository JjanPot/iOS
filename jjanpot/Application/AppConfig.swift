//
//  AppConfig.swift
//  jjanpot
//
//  Created by 임주희 on 4/5/26.
//

import Foundation

/// 앱 관련 설정을 관리하는 싱글톤 클래스
final class AppConfig {
    static let shared = AppConfig()

    private init() {}

    // MARK: - Tutorial
    @UserDefault(key: "hasCompletedTutorial", defaultValue: false)
    var hasCompletedTutorial: Bool

    @UserDefault(key: "hasViewedTutorial", defaultValue: false)
    var hasViewedTutorial: Bool

    // MARK: - App Version
    @UserDefault(key: "lastAppVersion", defaultValue: "")
    var lastAppVersion: String

    // MARK: - First Launch
    @UserDefault(key: "isFirstLaunch", defaultValue: true)
    var isFirstLaunch: Bool

    // MARK: - Settings
    @UserDefault(key: "isDarkModeEnabled", defaultValue: false)
    var isDarkModeEnabled: Bool

    @UserDefault(key: "isNotificationsEnabled", defaultValue: true)
    var isNotificationsEnabled: Bool

    // MARK: - User Preferences
    @UserDefault(key: "language", defaultValue: "ko")
    var language: String
    
    // MARK: - latestCompletedChallengeId
    @UserDefault(key: "latestCompletedChallengeId", defaultValue: nil)
    var latestCompletedChallengeId: Int?

    // MARK: - Reset
    /// 모든 설정을 기본값으로 리셋
    func reset() {
        hasCompletedTutorial = false
        hasViewedTutorial = false
        isDarkModeEnabled = false
        isNotificationsEnabled = true
        language = "ko"
        lastAppVersion = ""
        isFirstLaunch = true
    }
}
